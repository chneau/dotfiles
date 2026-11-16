#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.15"
# ///
"""Generate cross-platform alias blocks from aliases.toml."""

from __future__ import annotations

import argparse
import os
import re
import shutil
import subprocess
import sys
import tempfile
import tomllib
from pathlib import Path

ROOT = Path(__file__).resolve().parent
CONFIG_PATH = ROOT / "aliases.toml"

TARGETS = {
    "sh": {
        "path": ROOT / ".aliases",
        "start": "# >>> generated aliases >>>",
        "end": "# <<< generated aliases <<<",
    },
    "ps1": {
        "path": ROOT / ".profile.ps1",
        "start": "# >>> generated aliases >>>",
        "end": "# <<< generated aliases <<<",
    },
    "cmd": {
        "path": ROOT / ".profile.cmd",
        "start": ":: >>> generated aliases >>>",
        "end": ":: <<< generated aliases <<<",
    },
}


def resolve_value(spec: str | dict[str, str | bool], shell: str) -> str | None:
    """Return the command string for `shell`, or None if skipped."""
    if isinstance(spec, str):
        return spec
    if isinstance(spec, dict):
        val = spec.get(shell, False)
        return val if isinstance(val, str) else None
    raise TypeError(f"Unsupported alias spec: {spec!r}")


def format_line(shell: str, name: str, cmd: str) -> str:
    """Format a single alias definition for the target shell."""
    if shell == "sh":
        escaped = cmd.replace("'", "'\\''")
        return f"alias {name}='{escaped}'"
    if shell == "ps1":
        return f"function {name} {{ {cmd} @args }}"
    if shell == "cmd":
        return f"doskey {name}={cmd} $*"
    raise ValueError(f"Unknown shell: {shell}")


def render_block(data: dict[str, dict], shell: str) -> str:
    """Render all alias and function sections for a given shell."""
    comment = "::" if shell == "cmd" else "#"
    lines: list[str] = [TARGETS[shell]["start"]]
    for section, entries in data.items():
        if not isinstance(entries, dict):
            continue
        if section == "functions":
            for fn_name, spec in entries.items():
                if isinstance(spec, dict):
                    body = spec.get(shell)
                    if isinstance(body, str) and body.strip():
                        lines.append(body.rstrip())
            continue
        section_lines = []
        for name, spec in entries.items():
            cmd = resolve_value(spec, shell)
            if cmd is not None:
                section_lines.append(format_line(shell, name, cmd))
        if section_lines:
            lines.append(f"{comment} [{section}]")
            lines.extend(section_lines)
    lines.append(TARGETS[shell]["end"])
    return "\n".join(lines)


def update_file(path: Path, start: str, end: str, block: str, check: bool) -> bool:
    """Replace the marked block in `path`, or append it if missing. Returns True if changed."""
    content = path.read_text(encoding="utf-8") if path.exists() else ""
    pattern = re.compile(
        rf"^{re.escape(start)}.*?^{re.escape(end)}",
        flags=re.MULTILINE | re.DOTALL,
    )
    if pattern.search(content):
        new_content = pattern.sub(lambda _: block, content, count=1)
    else:
        sep = "\n\n" if content and not content.endswith("\n\n") else ("\n" if content and not content.endswith("\n") else "")
        new_content = f"{content}{sep}{block}\n"

    changed = new_content != content
    if changed and not check:
        path.write_text(new_content, encoding="utf-8")
    return changed


def ps1_syntax_errors(block: str) -> list[str]:
    """Parse `block` with PowerShell, if available, and return syntax errors.

    The generator appends `@args` to every alias body, so a body that is not a
    plain command (e.g. a bare expression or bash syntax such as `&` / `<(...)`)
    produces a profile that fails to load. Validate before writing.
    """
    shell = shutil.which("pwsh") or shutil.which("powershell")
    if shell is None:
        return []

    fd, tmp = tempfile.mkstemp(suffix=".ps1")
    try:
        with os.fdopen(fd, "w", encoding="utf-8") as f:
            f.write(block + "\n")
        script = (
            "$e=$null; $t=$null; "
            "[System.Management.Automation.Language.Parser]::ParseFile($env:PS1_TARGET,[ref]$t,[ref]$e) | Out-Null; "
            "$e | ForEach-Object { '{0}: {1}' -f $_.Extent.StartLineNumber, $_.Message }"
        )
        proc = subprocess.run(
            [shell, "-NoProfile", "-NonInteractive", "-Command", script],
            env={**os.environ, "PS1_TARGET": tmp},
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="replace",
        )
    finally:
        os.unlink(tmp)

    return [line.strip() for line in (proc.stdout + proc.stderr).splitlines() if line.strip()]


def main() -> int:
    parser = argparse.ArgumentParser(description="Sync aliases.toml to shell profiles.")
    parser.add_argument("--check", action="store_true", help="Exit non-zero if any file is out of date.")
    args = parser.parse_args()

    with CONFIG_PATH.open("rb") as f:
        data = tomllib.load(f)

    blocks = {shell: render_block(data, shell) for shell in TARGETS}
    errors = ps1_syntax_errors(blocks["ps1"])
    if errors:
        print(f"{TARGETS['ps1']['path'].name}: refusing to write, PowerShell syntax errors:", file=sys.stderr)
        for line in errors:
            print(f"  {line}", file=sys.stderr)
        return 1

    any_changed = False
    for shell, cfg in TARGETS.items():
        changed = update_file(cfg["path"], cfg["start"], cfg["end"], blocks[shell], check=args.check)
        any_changed = any_changed or changed
        status = "out of date" if (args.check and changed) else ("updated" if changed else "ok")
        print(f"{cfg['path'].name}: {status}")

    return 1 if (args.check and any_changed) else 0


if __name__ == "__main__":
    sys.exit(main())
