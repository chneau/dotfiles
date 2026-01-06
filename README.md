# Dotfiles

Bootstrap your environment with this one-liner:

```bash
x="raw.githubusercontent.com/chneau/dotfiles/master/bootstrap.sh"; (curl -fsSL $x || wget -qO - $x) | sh

bun install --global @chneau/x
```

## Overview

This repository contains personal configuration files for Linux/Unix environments, designed to streamline development and system administration. It features a robust set of aliases, a custom shell prompt with performance metrics, and utility functions for everyday tasks.

## Key Components

- **`.aliases`**: The powerhouse of this setup. Contains hundreds of shortcuts and functions.
- **`.bashrc`**: Bash configuration featuring a custom prompt with execution timing and status indicators.
- **`.zshrc`**: Zsh configuration ensuring a consistent experience across shells.
- **`bootstrap.sh`**: The installer script that sets everything up.

## Features & Aliases

### ⚡ Productivity Aliases

- **General**: `ll` (detailed list), `grep` (auto-colored), `c` (clear).
- **Git**:
  - `gs`: `git status -sb`
  - `gp`: `git push`
  - `gl`: `git pull`
  - `gc`: `git commit -v`
  - `gd`: `git diff`
- **Docker**:
  - `d`: `docker`
  - `dps`: Colorized `docker ps`
  - `dl`: Follow docker logs (`docker logs -f --tail 40`)
  - `dc`: `docker-compose`
- **Kubernetes**:
  - `k`: `kubectl`
  - `kg`: `kubectl get`
  - `kl`: `kubectl logs`
  - `kctx` / `kns`: Switch context and namespace.

### 🛠 Utility Functions

- **`extract <file>`**: Intelligently extracts any archive (`.tar.gz`, `.zip`, `.rar`, `.bz2`, etc.).
- **`transfer <file>`**: Uploads a file to `transfer.sh` and returns a shareable URL.
- **`gitget <url>`**: Clones a repository into a Go-style directory structure (`~/go/src/...`).
- **`dockertags <image>`**: Lists available tags for a Docker image from the registry.
- **`curlt`**: A `curl` wrapper that prints detailed timing information (DNS lookup, connect time, etc.).

### 📦 Quick Installers

Easily install tools using `i`-prefixed aliases:

- `igo`: Install Go.
- `idocker`: Install Docker.
- `ik3s` / `ik8s`: Install Kubernetes distributions.
- `inix`: Install Nix.
- `ibun`: Install Bun.
- `igemini`: Install Gemini CLI.
- `iqwen`: Install Qwen.

### 🖥 Custom Prompt

The shell prompt is configured to display:

- **Status**: Green checkmark (✔) or red cross (✘) for the last command's exit code.
- **Timing**: Execution time of the last command (e.g., `(1m3s)`).
- **Context**: User, hostname, and current directory.

## Usage

### Updates

To update your configuration to the latest version from this repository, simply run:

```bash
updatebashrc
```

### Miscellaneous

The `.stuff/` directory contains additional scripts, legacy configurations, and platform-specific files (e.g., for Windows/WSL).

### Windows

```bash
Set-ExecutionPolicy Unrestricted -Scope Process -Force
irm https://christitus.com/win | iex
```
