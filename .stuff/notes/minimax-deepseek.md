# Point MiniMax Code (`mcode`) at DeepSeek

This is how MiniMax Code (`@minimax-ai/code`, binary `mcode`) was configured to use a
DeepSeek API key that was already present on the machine.

> The actual key is **not** written here. It lives only in `~/.minimax/config.yaml`
> (and in the original `pi` / `reasonix` files). Every command below reads it into an
> environment variable instead of pasting it into a shell history or a doc.

## Background

`mcode` keeps its state under `~/.minimax` (override with `MINIMAX_DATA_DIR`).

| File / dir                     | Purpose                                             |
| ------------------------------ | --------------------------------------------------- |
| `~/.minimax/config.yaml`       | models, providers, default model                     |
| `~/.minimax/auth/`             | managed MiniMax login tokens (leave alone)            |
| `~/.minimax/v2/sqlite/`        | runtime state (sessions, usage)                       |

Inside `config.yaml` there are two different provider shapes:

- `provider:` — the built-in provider(s), e.g. `minimax`.
- `custom_provider:` — third-party / BYOK providers added with `mcode provider add`.

DeepSeek is OpenAI-compatible, so it is added under `custom_provider`.

## 1. Locate the existing DeepSeek key

The key was already used by two other tools on this machine, and both held the **same**
value:

- **pi** — `~/.pi/agent/auth.json`:

  ```json
  { "deepseek": { "type": "api_key", "key": "sk-…" } }
  ```

- **reasonix** — `~/.reasonix/.env`:

  ```dotenv
  DEEPSEEK_API_KEY=sk-…
  ```

Read one of them into an environment variable so the key never appears on screen:

```bash
export DEEPSEEK_API_KEY="$(
  python3 -c "import json;print(json.load(open('$HOME/.pi/agent/auth.json'))['deepseek']['key'])"
)"
```

Sanity check without printing the secret (compare only prefixes/lengths, or compare the
two sources):

```bash
python3 - <<'PY'
import json, re, os
pi = json.load(open(os.path.expanduser("~/.pi/agent/auth.json")))["deepseek"]["key"]
env = open(os.path.expanduser("~/.reasonix/.env")).read()
rk = re.search(r"DEEPSEEK_API_KEY=(.*)", env).group(1).strip().strip('"')
print("same key:", pi == rk, "| length:", len(pi))
PY
```

## 2. Know the model IDs

The DeepSeek models already known to `pi` (`~/.pi/agent/models-store.json`) are
`deepseek-flash` (vision + reasoning) and `deepseek-v4-pro`, both on
`https://api.deepseek.com` using the `openai-completions` API.

## 3. Test on a throwaway data dir first (optional but recommended)

Do the whole thing in a scratch directory before touching the real config:

```bash
export DEEPSEEK_API_KEY="$(
  python3 -c "import json;print(json.load(open('$HOME/.pi/agent/auth.json'))['deepseek']['key'])"
)"

rm -rf /tmp/mcode-test && mkdir -p /tmp/mcode-test
cd /tmp && MINIMAX_DATA_DIR=/tmp/mcode-test mcode provider add \
  --name DeepSeek \
  --base-url https://api.deepseek.com \
  --api-format openai-completions \
  --model deepseek-flash \
  --model deepseek-v4-pro \
  --api-key-env DEEPSEEK_API_KEY
```

Inspect the generated `config.yaml` and then delete the scratch dir:

```bash
cat /tmp/mcode-test/config.yaml
rm -rf /tmp/mcode-test
```

### Gotcha: `--use` fails on a fresh add

`mcode provider add … --use` exits with:

```
Test the saved provider configuration before activating it
```

That is intentional — the tool refuses to *activate* a provider before it has been
tested. So: **add without `--use`, test, then set the default model yourself.**

## 4. Configure the real data dir

```bash
# 0. back up first
cp -a ~/.minimax/config.yaml ~/.minimax/config.yaml.bak-$(date +%Y%m%d-%H%M%S)

# 1. add the provider (key comes from the env var, not the CLI history)
export DEEPSEEK_API_KEY="$(
  python3 -c "import json;print(json.load(open('$HOME/.pi/agent/auth.json'))['deepseek']['key'])"
)"
cd /tmp && mcode provider add \
  --name DeepSeek \
  --base-url https://api.deepseek.com \
  --api-format openai-completions \
  --model deepseek-flash \
  --model deepseek-v4-pro \
  --api-key-env DEEPSEEK_API_KEY
```

`mcode` writes the key inline (redacted here) into `custom_provider`:

```yaml
custom_provider:
  deepseek:
    name: DeepSeek
    kind: custom
    enabled: true
    api: openai-completions
    options:
      apiKey: sk-…            # stored here, read at runtime
      baseURL: https://api.deepseek.com
      authMode: api-key
    models:
      deepseek-flash:
        reasoning: true
      deepseek-v4-pro:
        reasoning: true
```

That is what `mcode provider add` generates. `reasoning: true` only makes a model
*thinking-capable*; it does **not** expose depth settings — see step 7 for that.

## 5. Test the provider

```bash
mcode provider test custom_provider:deepseek
# -> Provider available: custom_provider:deepseek
```

List everything:

```bash
mcode provider list
# * minimax_oauth            active   managed login
#   minimax_api              enabled  no key
# * custom_provider:deepseek active   sk-…****…
```

## 6. Make DeepSeek the default model

`config.yaml`, top of the file:

```yaml
defaultModel: custom_provider:deepseek/deepseek-flash
```

The format is `<provider-id>/<model-id>`; custom providers use the
`custom_provider:<name>` provider id.

## 7. Enable graded thinking levels

With only `reasoning: true` the model is thinking-capable but the TUI model picker just
says "thinking on" — there is nothing to grade. Thinking depth is a **level**, and the
level ladder only shows up once the model entry declares which levels it supports.

The levels and what they cost (from the bundled runtime):

| Level     | Meaning                            |
| --------- | ---------------------------------- |
| `off`     | No reasoning                       |
| `minimal` | ~1k tokens                         |
| `low`     | ~2k tokens                         |
| `medium`  | ~8k tokens (built-in default)      |
| `high`    | ~16k tokens                        |
| `xhigh`   | ~32k tokens                        |
| `max`     | Maximum model-supported reasoning  |

Add a `thinking:` block (camelCase keys) to each model by hand-editing `config.yaml`:

```yaml
custom_provider:
  deepseek:
    # … unchanged …
    models:
      deepseek-flash:
        reasoning: true
        thinking:
          effortOptions: [off, minimal, low, medium, high, xhigh, max]
          defaultEffort: medium
      deepseek-v4-pro:
        reasoning: true
        thinking:
          effortOptions: [off, minimal, low, medium, high, xhigh, max]
          defaultEffort: medium
```

- `effortOptions` is the part that matters: it is what populates the model's
  `availableThinkingLevels`. Omit it and the model has no levels to offer.
- Including `off` keeps a plain on/off choice available alongside the graded ones.
- `thinking.defaultEffort` sets the starting level; leave it out to fall back to the
  built-in default (`medium`).
- `thinking_config` (`mode: switchable` / `forced_on` / `forced_off`) is a **different**
  key and cannot express a level. Use it for the default on/off state, `thinking` for
  depth.
- Trimming `effortOptions` hides the levels you drop — the simplest way to stop a model
  from quietly spending 32k reasoning tokens.

In the TUI the setting lives at `/settings` → **Thinking level** ("Reasoning depth for
thinking-capable models"), and the value is persisted as `defaultThinkingLevel` in
`~/.minimax/v2/sqlite/runtime-state.sqlite` — there is no hand-editable JSON for it.

For one-off runs, pick a level with `--effort`:

```bash
mcode exec --effort xhigh "…"
```

> **Trap:** an effort level is *not* a model variant.
> `--model custom_provider:deepseek/deepseek-flash#xhigh` will run, but the `#xhigh`
> suffix is parsed as part of the model identity and the level is silently dropped. Use
> `--effort` when the level actually has to take effect. (`#thinking` /
> `#none-thinking` suffixes are real variants — that is a separate mechanism.)
>
> `--effort` is a per-invocation override: it is never written back to the session, so a
> later `--continue` / `--session` run restores the session's own level.

Note that `mcode provider add --help` has no thinking/effort flags at all (`--name`,
`--base-url`, `--api-format`, `--model`, `--api-key-env`, `--use` only), so graded levels
always mean hand-editing `config.yaml`.

> **Status:** the keys and level ladder were read out of the installed bundle
> (`@minimax-ai/code` 0.4.12), then confirmed against a live run. Asking for a level that
> is not in `effortOptions` fails loudly and echoes the ladder back, which is the
> quickest way to check the block was picked up:
>
> ```
> $ mcode exec --effort turbo "…"
> mcode exec failed: --effort turbo is not available for
> custom_provider:deepseek/deepseek-flash. Available levels: off, minimal, low, medium, high, xhigh, max.
> ```
>
> What is *not* settled is how far DeepSeek actually goes along with it. On the same
> prompt `--effort max` produced a visibly longer deliberation than `--effort off`
> (77 output tokens vs 1), but the reported `reasoningTokens` stayed `0` in both cases —
> so treat the per-level token budgets in the table above as the runtime's intent, not
> as something the provider was observed to bill for.

## 8. Verify end to end

```bash
cd /tmp && mcode exec --output-format json "Reply with the single word: ok"
```

A working run reports the provider actually used:

```json
{
  "status": "succeeded",
  "output": "ok",
  "model": {
    "providerId": "custom_provider:deepseek",
    "modelId": "deepseek-flash",
    "protocol": "openai-completions"
  }
}
```

Then repeat it with an explicit level:

```bash
cd /tmp && mcode exec --effort high --output-format json "Reply with the single word: ok"
```

The runtime validates the level against the model's advertised levels before the turn
starts and exits non-zero if it is unsupported, so a `"status": "succeeded"` run is also
proof that the `effortOptions` from step 7 were picked up. The JSON payload itself reports
provider/model, not the effort — the level that actually stuck is visible at
`/settings` → **Thinking level**.

## 9. Lock down the file

Because `config.yaml` now contains a plaintext key, restrict it:

```bash
chmod 600 ~/.minimax/config.yaml
```

## Switching / reverting

- Switch model at runtime with `/model` inside the TUI, or
  `mcode exec --model custom_provider:deepseek/deepseek-v4-pro "…"`.
- The built-in MiniMax provider is untouched, so you can switch back to it with `/model`.
- Thinking depth is the per-model `thinking:` block from step 7; deleting that block (or
  trimming `effortOptions`) reverts the model to plain on/off thinking.
- Full rollback: restore the backup created in step 4
  (`~/.minimax/config.yaml.bak-<timestamp>`) or
  `mcode provider remove custom_provider:deepseek --yes`.

## Security notes

- Never commit `~/.minimax/config.yaml` — it holds the API key in plaintext.
- Prefer `--api-key-env SOME_ENV_VAR` if you would rather not persist the key in the
  file; `mcode` will then read it from the environment at runtime.
- The key was reused from `pi` / `reasonix` rather than creating a new one; rotate it in
  the DeepSeek dashboard and update all three tools if it ever leaks.
