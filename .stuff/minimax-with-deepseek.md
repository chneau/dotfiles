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

## 7. Verify end to end

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

## 8. Lock down the file

Because `config.yaml` now contains a plaintext key, restrict it:

```bash
chmod 600 ~/.minimax/config.yaml
```

## Switching / reverting

- Switch model at runtime with `/model` inside the TUI, or
  `mcode exec --model custom_provider:deepseek/deepseek-v4-pro "…"`.
- The built-in MiniMax provider is untouched, so you can switch back to it with `/model`.
- Full rollback: restore the backup created in step 4
  (`~/.minimax/config.yaml.bak-<timestamp>`) or
  `mcode provider remove custom_provider:deepseek --yes`.

## Security notes

- Never commit `~/.minimax/config.yaml` — it holds the API key in plaintext.
- Prefer `--api-key-env SOME_ENV_VAR` if you would rather not persist the key in the
  file; `mcode` will then read it from the environment at runtime.
- The key was reused from `pi` / `reasonix` rather than creating a new one; rotate it in
  the DeepSeek dashboard and update all three tools if it ever leaks.
