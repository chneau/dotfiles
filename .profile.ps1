# PowerShell Dotfiles & Aliases for Windows
# Compatible with Windows PowerShell 5.1 and PowerShell 7+ (pwsh)

# ==============================================================================
# 0. Shell Configuration & Built-in Conflict Resolution
# ==============================================================================

# Ensure UTF-8 output encoding
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# Remove built-in aliases that conflict with standard CLI utilities
$conflicts = @('curl', 'wget', 'diff', 'cp', 'rm', 'ls', 'sc', 'mv', 'cat', 'gc', 'gp', 'gl', 'ga', 'measure')
foreach ($c in $conflicts) {
    if (Get-Alias -Name $c -ErrorAction SilentlyContinue) {
        Remove-Item "Alias:$c" -Force -ErrorAction SilentlyContinue
    }
}

# ==============================================================================
# 1. Environment Variables (Ported from .profile)
# ==============================================================================

$env:DOCKER_BUILDKIT = "1"
$env:BUILDX_EXPERIMENTAL = "1"
$env:NODE_OPTIONS = "--max_old_space_size=4096"
$env:CARGO_NET_GIT_FETCH_WITH_CLI = "true"
$env:DOTNET_WATCH_RESTART_ON_RUDE_EDIT = "true"
$env:NPM_CONFIG_YES = "true"
$env:NPM_CONFIG_FUND = "false"
$env:BUN_CONFIG_NO_CLEAR_TERMINAL_ON_RELOAD = "1"
$env:DO_NOT_TRACK = "1"
$env:FORCE_COLOR = "1"
$env:BAT_PAGING = "never"
$env:BAT_STYLE = "plain"
$env:BAT_TABS = "2"
$env:DOTNET_CLI_TELEMETRY_OPTOUT = "1"

# Fast PATH extensions (only added if directory exists on Windows)
$candidatePaths = @(
    (Join-Path $HOME ".cargo\bin"),
    (Join-Path $HOME ".dotnet\tools"),
    (Join-Path $HOME ".dotnet"),
    (Join-Path $HOME ".bun\bin"),
    (Join-Path $HOME "go\bin"),
    (Join-Path $HOME ".deno\bin"),
    (Join-Path $HOME ".pulumi\bin"),
    (Join-Path $HOME ".kilo\bin"),
    (Join-Path $HOME ".local\bin"),
    (Join-Path $HOME "bin")
)

$currentPathEntries = $env:PATH -split ';'
$pathsToAdd = @()
foreach ($p in $candidatePaths) {
    if ((Test-Path $p) -and ($currentPathEntries -notcontains $p)) {
        $pathsToAdd += $p
    }
}
if ($pathsToAdd.Count -gt 0) {
    $env:PATH = ($pathsToAdd -join ';') + ';' + $env:PATH
}

# ==============================================================================
# 2. Custom Prompt with Timer & Exit Code (Ported from .bashrc)
# ==============================================================================

# Enable ANSI escape sequences support if in Windows PowerShell 5.1 / ConHost
$Esc = [char]27
$Reset = "$Esc[0m"
$Green = "$Esc[1;32m"
$Red   = "$Esc[1;31m"
$Blue  = "$Esc[1;34m"
$White = "$Esc[1;37m"

# Timer setup: Measure only actual command execution time (not idle prompt time)
# We hook the Enter key via PSReadLine so the stopwatch starts only when you hit Enter.
$global:__cmdWatch = $null

if (Get-Module -ListAvailable PSReadLine) {
    try {
        Import-Module PSReadLine -ErrorAction SilentlyContinue
        Set-PSReadLineKeyHandler -Key Enter -ScriptBlock {
            $global:__cmdWatch = [System.Diagnostics.Stopwatch]::StartNew()
            [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
        }
    } catch {}
}

function prompt {
    $lastExit = $global:LASTEXITCODE
    $lastSuccess = $?

    # Calculate duration of the executed command only
    $durationStr = ""
    if ($global:__cmdWatch -and $global:__cmdWatch.IsRunning) {
        $global:__cmdWatch.Stop()
        $elapsedMs = $global:__cmdWatch.ElapsedMilliseconds
        $global:__cmdWatch = $null

        if ($elapsedMs -ge 60000) {
            $mins = [math]::Floor($elapsedMs / 60000)
            $secs = [math]::Floor(($elapsedMs % 60000) / 1000)
            $durationStr = "{0}m{1}s" -f $mins, $secs
        } elseif ($elapsedMs -ge 1000) {
            $durationStr = "{0:N1}s" -f ($elapsedMs / 1000)
        } else {
            $durationStr = "{0}ms" -f $elapsedMs
        }
    }

    # Exit icon & status code
    $statusIcon = if ($lastSuccess -and ($lastExit -eq 0 -or $null -eq $lastExit)) {
        "$Green[OK]$Reset"
    } else {
        "$Red[ERR:$lastExit]$Reset"
    }

    $timeNow = Get-Date -Format "HH:mm:ss"
    $userHost = "$Green$env:USERNAME@$env:COMPUTERNAME$Reset"
    $currDir = "$Blue$(Get-Location)$Reset"

    $timerDisplay = if ($durationStr) { "($durationStr) " } else { "" }

    return "$statusIcon $timerDisplay$White$timeNow$Reset $userHost $currDir $Blue>$Reset "
}

# ==============================================================================
# 3. Navigation
# ==============================================================================
function .. { Set-Location .. }
function ... { Set-Location ..\.. }
function .... { Set-Location ..\..\.. }

# ==============================================================================
# 4. General CLI & File System
# ==============================================================================
function l { Get-ChildItem -Force @args }
function la { Get-ChildItem -Force @args }
function ll { Get-ChildItem -Force @args }
function lh { Get-ChildItem -Force @args }
function ls {
    if (Get-Command ls.exe -ErrorAction SilentlyContinue) {
        & ls.exe --color=auto @args
    } else {
        Get-ChildItem @args
    }
}

function grep {
    if (Get-Command rg.exe -ErrorAction SilentlyContinue) {
        & rg.exe @args
    } elseif (Get-Command grep.exe -ErrorAction SilentlyContinue) {
        & grep.exe --color=auto @args
    } else {
        Select-String @args
    }
}
function egrep { grep -E @args }
function fgrep { grep -F @args }
function gr { grep -C5 @args }
function grephere { grep -rnw . -e @args }
function findtext { grep -rnw . -e @args }

function diff {
    if (Get-Command diff.exe -ErrorAction SilentlyContinue) {
        & diff.exe -u -w @args
    } elseif (Get-Command git.exe -ErrorAction SilentlyContinue) {
        & git.exe diff --no-index @args
    } else {
        Compare-Object @args
    }
}

function path { ($env:PATH -split ';') }
function now { Get-Date -Format "HH:mm:ss" }
function nowdate { Get-Date -Format "dd-MM-yyyy" }
function nowtime { now }

function mkcdir($dir) {
    if (-not $dir) { Write-Error "Usage: mkcdir <directory>"; return }
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    Set-Location $dir
}

function tobase64 {
    $inputStr = ($input | Out-String)
    if ($inputStr) {
        [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($inputStr))
    }
}

# ==============================================================================
# 5. Git Shortcuts
# ==============================================================================
function ga { git add @args }
function gb { git branch --sort=-committerdate -vv @args }
function gba { git branch --sort=-committerdate -vva @args }
function gc { git commit -v @args }
function gca { git commit . -v @args }
function gcam { git commit -a -m @args }
function gcl { git clone @args }
function gco { git checkout @args }
function gcom { git checkout master @args }
function gd { git diff @args }
function gg {
    git pull -f
    $defaultBranch = if (& git show-ref --verify --quiet refs/remotes/origin/main) { "main" } else { "master" }
    git reset --hard "origin/$defaultBranch"
}
function gigit { git clone --depth=1 @args }
function gl { git pull @args }
function gla { git pull --all @args }
function glom { git pull origin master @args }
function glog {
    git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative @args
}
function gp { git push @args }
function gpm {
    $curBranch = git branch --show-current
    git push origin "${curBranch}:master" @args
}
function gpcb($target) {
    if (-not $target) { Write-Error "Usage: gpcb <target-branch>"; return }
    $curBranch = git branch --show-current
    git push origin "${curBranch}:${target}"
}
function gs { git status -sb @args }
function gsc { git switch -c @args }
function gsw { git switch @args }
function gsta { git stash push @args }
function gstd { git stash drop @args }
function gstl { git stash list @args }
function gstp { git stash pop @args }
function grb {
    git fetch --all
    git for-each-ref --sort=-committerdate --format='%(HEAD) %(color:blue)%(authordate:iso) %(color:red)%(objectname:short) %(color:yellow)%(refname:short) %(color:reset)%(contents:subject) %(color:magenta)%(authorname) %(color:green)%(committerdate:relative)' refs
}
function grba { git rebase --abort @args }
function grbc { git rebase --continue @args }
function grm {
    $deleted = git ls-files --deleted
    if ($deleted) { $deleted | ForEach-Object { git rm $_ } }
}
function gitclean {
    git reflog expire --expire=now --all
    git repack -ad
    git prune
    git fetch --prune --prune-tags
    git clean -ffdx
}
function gitnewfresh { git checkout --orphan @args }
function gitrmtag { git push -d origin @args }
function gitmessage { (Invoke-RestMethod "https://whatthecommit.com/index.txt").Trim() }

function igit {
    git config --global user.email "charles63500@gmail.com"
    git config --global user.name "chneau"
    git config --global url.ssh://git@github.com/.insteadOf https://github.com/
    git config --global merge.ff false
    git config --global pull.ff true
    git config --global core.whitespace blank-at-eol,blank-at-eof,space-before-tab,cr-at-eol
    git config --global fetch.prune true
    git config --global pull.rebase true
    Write-Host "Configured git global settings." -ForegroundColor Green
}

function gocd($repo) {
    if (-not $repo) { Write-Error "Usage: gocd <repo>"; return }
    $clean = $repo -replace '^.*://', ''
    $dest = Join-Path $HOME "go\src\$clean"
    if (Test-Path $dest) { Set-Location $dest } else { Write-Warning "Directory not found: $dest" }
}

function gitget($url) {
    if (-not $url) { Write-Error "Usage: gitget <git-url>"; return }
    $gitUrl = if ($url -notmatch '^.*://') { "https://$url" } else { $url }
    $repoName = $url -replace '^.*://', ''
    $cloneDir = Join-Path $HOME "go\src\$repoName"

    Write-Host "Cloning $repoName into $cloneDir..."
    if (Test-Path $cloneDir) { Remove-Item -Recurse -Force $cloneDir }
    New-Item -ItemType Directory -Force -Path $cloneDir | Out-Null
    git clone --quiet $gitUrl $cloneDir
    if (Test-Path $cloneDir) { Set-Location $cloneDir }
}

function gitgetc($repo) {
    gitget "https://github.com/chneau/$repo"
}

# ==============================================================================
# 6. Docker & Kubernetes
# ==============================================================================
function d { docker @args }
function db { docker build --pull --tag @args }
function dbpush { docker build --pull --push --tag @args }
function dbtest { docker build --pull --tag test . @args }
function dc { docker compose @args }
function ddown {
    $running = docker ps -a -q
    if ($running) { docker stop $running }
}
function de { docker exec -it @args }
function di { docker images @args }
function dkill {
    $running = docker ps -q
    if ($running) { docker kill $running }
}
function dkilla {
    $running = docker ps -a -q
    if ($running) { docker stop $running }
}
function dl { docker logs --tail 40 -f @args }
function dprune {
    docker system prune --force --volumes
    docker volume prune --force
}
function dprunea {
    docker system prune --force --volumes --all
    docker volume prune --force --all
}
function dps { docker ps @args }
function drm {
    $dangling = docker images -q --filter "dangling=true"
    if ($dangling) { docker rmi $dangling }
}
function ds { docker stats @args }
function dsdf { docker system df @args }
function dsi { docker service inspect --pretty @args }
function dsl { docker service logs -f @args }
function dsls { docker service ls --tail 40 @args }
function dt { docker run --rm -it @args }
function dtest { docker run --rm -it --name test --hostname test @args }

# Kubernetes
function k { kubectl @args }
function ka { kubectl apply -f @args }
function kak { kubectl apply -k @args }
function kar { kubectl api-resources @args }
function kconf { kubectl config view --raw @args }
function kdes { kubectl describe @args }
function kdestroy { kubectl delete --grace-period=0 --force @args }
function kdn { kubectl describe node @args }
function ke { kubectl exec -ti @args }
function kenv { kubectl set env pods --all --list @args }
function kex { kubectl explain @args }
function kg { kubectl get @args }
function kga { kubectl get all,ingress @args }
function kgaa { kubectl get all,ingress --all-namespaces @args }
function kgd { kubectl get deployment,statefulset,daemonset,cronjob @args }
function kge { kubectl get events @args }
function kgea { kubectl get events --all-namespaces @args }
function kgia { kubectl get ingress --all-namespaces @args }
function kgpa { kubectl get pods --all-namespaces @args }
function kgs { kubectl get secret @args }
function kk { kubectl kustomize @args }
function kkill { kubectl delete pods --grace-period=0 --force --all @args }
function kl { kubectl logs -f --tail=40 @args }
function kll { kubectl logs -f --tail=40 --timestamps --prefix @args }
function kpf { kubectl port-forward @args }
function kr { kubectl rollout @args }
function krr { kubectl rollout restart @args }
function ktn { kubectl top nodes @args }
function ktp { kubectl top pods --sort-by=memory @args }
function ktpa { kubectl top pods --all-namespaces --sort-by=memory @args }
function kw { kubectl get po -w @args }

# ==============================================================================
# 7. Language Tools & Runtimes (Bun, Node, Go, Python/uv, DotNet, Zig, Rust)
# ==============================================================================

# Bun
function b { bun @args }
function bbmd { bun build --metafile-md @args }
function bbx { bun --bun x @args }
function bcp { bun --cpu-prof-md @args }
function bcphp { bun --cpu-prof-md --heap-prof-md @args }
function bd { bun run dev @args }
function bfmt { biome check --write --unsafe . @args }
function bh { bun --hot --no-clear-screen @args }
function bhp { bun --heap-prof-md @args }
function bi { bun install --force --no-save @args }
function bic { biome check --write --unsafe . @args }
function bo { bun outdated @args }
function br { bun run @args }
function brp { bun run --parallel @args }
function brs { bun run --sequential @args }
function bs { bun start @args }
function bw { bun --watch --no-clear-screen @args }
function bx { bun x @args }
function bxb { bun --bun x @args }
function ibun { powershell -c "irm bun.sh/install.ps1 | iex" }

# Node & NPM
function npme { npm exec --yes -- @args }
function ncup { npm-check-updates --upgrade --install=always --packageManager=bun --deep @args }
function npmup { npm-check-updates --deep --upgrade --install=always --packageManager=bun @args }
function npmig {
    $pkgs = @(
        'npm@latest', 'opencode-ai@latest', 'oxlint@latest', '@chneau/x',
        '@biomejs/biome@latest', 'http-server@latest', 'live-server@latest',
        'fkill-cli@latest', 'ungit@latest', 'tsx@latest', 'npm-check-updates@latest',
        'nodemon@latest', 'prettier@latest', 'typesync@latest', 'depcheck@latest',
        'concurrently@latest', 'ts-unused-exports@latest', '@qwen-code/qwen-code@latest',
        'jsdoc-scribe@latest'
    )
    if (Get-Command bun -ErrorAction SilentlyContinue) {
        bun install --force --global --silent $pkgs
        bun update --global --latest --force
    } else {
        npm install --global $pkgs
    }
}
function tsfmt { biome check --write --unsafe . @args }
function tslint { tsc --noEmit --project . @args }
function tsall {
    ncup
    biome check --write --unsafe .
    depcheck
    ts-unused-exports tsconfig.json
    tsc --noEmit --project .
}

# Go
function gobuild {
    $env:CGO_ENABLED = "0"
    go build -trimpath -ldflags '-s -w' @args
}
function goi { go install @args }
function goinst($pkg) {
    if (-not $pkg) { Write-Error "Usage: goinst <pkg>"; return }
    $clean = $pkg -replace '^.*://', ''
    go install "${clean}@latest"
}
function gotest { go test -cover -count=1 @args }
function gotestfast { go test -v ./... @args }
function gotidy {
    go mod tidy
    go mod verify
}
function goup {
    Remove-Item go.mod, go.sum -ErrorAction SilentlyContinue
    go mod init
    go get -u
    go mod tidy
}

# Python & uv
function pipi { uv pip install --upgrade @args }
function pipig { uv tool install @args }
function pipup { uv pip install --upgrade @args }
function pipupg { uv tool upgrade --all @args }
function genuuid { uv run python -c "import uuid; print(uuid.uuid4())" }
function servepy { uv run python -m http.server @args }
function webshare { uv run python -m http.server @args }
function iuv { powershell -c "irm https://astral.sh/uv/install.ps1 | iex" }

# .NET
function dotnetfmt { dotnet csharpier . @args }
function dotnethttps {
    dotnet dev-certs https --clean
    dotnet dev-certs https --trust
}
function dotneti($tool) {
    if (-not $tool) { Write-Error "Usage: dotneti <tool>"; return }
    dotnet tool install --global $tool
    if ($LASTEXITCODE -ne 0) { dotnet tool update --global $tool }
}
function dotnetig {
    $tools = @('dotnet-outdated-tool', 'Roslynator.DotNet.Cli', 'dotnet-ef', 'dotnet-serve', 'PowerShell', 'CSharpier', 'CentralisedPackageConverter', 'dotnet-symbol')
    foreach ($t in $tools) { dotneti $t }
}
function dotnetup { dotnet outdated --upgrade @args }

# Zig
function z { zig @args }
function zb { zig build @args }
function zbr { zig build run @args }
function zr { zig run @args }

# ==============================================================================
# 8. AI Coding Assistants & CLI Tools
# ==============================================================================
function cl { claude @args }
function cly { claude --dangerously-skip-permissions @args }
function iclaude { powershell -c "irm https://claude.ai/install.ps1 | iex" }
function agyy { agy --dangerously-skip-permissions @args }
function iagy { powershell -c "irm https://antigravity.google/cli/install.ps1 | iex" }
function igravitycli { iagy }
function agenty { agent --yolo @args }
function codexy { codex --dangerously-bypass-approvals-and-sandbox @args }
function icodex { powershell -c "irm https://chatgpt.com/codex/install.ps1 | iex" }
function icopilot { bun i -g @github/copilot@latest }
function icursor { powershell -c "irm https://cursor.com/install.ps1 | iex" }
function ocy { opencode --auto @args }
function opencodey { opencode --auto @args }
function iopencode { powershell -c "irm https://opencode.ai/install.ps1 | iex" }
function kiloy { kilo --auto @args }
function hermesy { hermes --yolo @args }
function reasonixy { reasonix --permission-mode bypassPermissions @args }
function ry { reasonix --permission-mode bypassPermissions --yolo @args }
function rw { reasonix web @args }
function ireasonix { bun i -g reasonix@latest }
function iqwen { bun install -fg @qwen-code/qwen-code@latest }
function ifreebuff { bun i -g freebuff@latest }
function icommandcode { bun i -g command-code@latest }
function ideepcode { bun i -g @vegamo/deepcode-cli@latest }
function irtk { powershell -c "irm https://raw.githubusercontent.com/rtk-ai/rtk/master/install.ps1 | iex" }
function ix { bun install --force --global @chneau/x }

function aihelp {
    @"
AI CLI Tools & Assistants (Windows / PowerShell)
================================================

Tool       Provider / Vendor       Aliases                 Description
----       -----------------       -------                 -----------
claude     Anthropic               cl, cly                 Claude AI coding assistant & agent
cline      Cline                   -                       Cline AI coding agent
agy        Google DeepMind         agyy                    Antigravity agentic coding assistant CLI
agent      Cursor / Anysphere      agenty                  Cursor AI terminal agent & CLI
codex      OpenAI                  codexy                  ChatGPT / Codex terminal coding agent
copilot    GitHub / Microsoft      -                       GitHub Copilot CLI
qwen       Alibaba Cloud           -                       Qwen Code terminal coding assistant
reasonix   Reasonix AI             ry, reasonixy, rw       Reasoning AI assistant CLI & web UI
opencode   OpenCode AI             ocy, opencodey          Multi-provider open-source coding assistant
kilo       Kilo AI                 kiloy                   Kilo AI coding agent CLI
hermes     Nous Research           hermesy                 Hermes agentic coding assistant CLI
rtk        RTK AI                  -                       RTK AI developer toolkit CLI
"@
}

function clihelp {
    @"
3rd-Party CLI Tools (Windows / PowerShell)
==========================================

Cloud & Hosting:
  az         Azure (Microsoft Cloud)
  aws        Amazon Web Services
  gcloud     Google Cloud Platform
  doctl      DigitalOcean
  cf         Cloudflare

Developer Platforms:
  gh         GitHub CLI
  jira       Jira CLI

Media & Utilities:
  yt-dlp     YouTube & video platform downloader
  weather    wttr.in weather lookup
  curlt      HTTP request timing inspection
"@
}

# ==============================================================================
# 9. Network & Web Utilities
# ==============================================================================
function myip {
    try { (Invoke-RestMethod "https://icanhazip.com").Trim() }
    catch { (Invoke-RestMethod "https://api.ipify.org").Trim() }
}
function mip { myip }
function mh { (Invoke-RestMethod "https://ifconfig.me/host").Trim() }
function weather($city) {
    $url = if ($city) { "https://wttr.in/$city" } else { "https://wttr.in" }
    (Invoke-RestMethod $url)
}

function curlt($url) {
    if (-not $url) { Write-Error "Usage: curlt <url>"; return }
    if (Get-Command curl.exe -ErrorAction SilentlyContinue) {
        & curl.exe -so NUL -w "
   namelookup:  %{time_namelookup}s
      connect:  %{time_connect}s
   appconnect:  %{time_appconnect}s
  pretransfer:  %{time_pretransfer}s
     redirect:  %{time_redirect}s
starttransfer:  %{time_starttransfer}s
-------------------------
        total:  %{time_total}s`n" $url
    } else {
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        $resp = Invoke-WebRequest -Uri $url -UseBasicParsing
        $sw.Stop()
        Write-Host ("Status: {0} ({1} ms)" -f $resp.StatusCode, $sw.ElapsedMilliseconds)
    }
}

# Fast Windows Activation / Utilities
function imas { irm https://massgrave.dev/get | iex }
function idefendnot { irm https://dnot.sh/ | iex }

# ==============================================================================
# 10. Media Utilities (yt-dlp)
# ==============================================================================
function yt { yt-dlp @args }
function ymp4 { yt-dlp -S res,ext:mp4:m4a --recode mp4 @args }
function ymp4s { yt-dlp -S res,ext:mp4:m4a --recode mp4 --embed-subs --sub-lang en --add-metadata --convert-subs srt --embed-thumbnail @args }
function ymp3 {
    yt-dlp --restrict-filenames --continue --ignore-errors --download-archive downloaded.txt `
           --no-post-overwrites --no-overwrites --extract-audio --audio-format mp3 `
           --output "%(title)s.%(ext)s" @args
}

# ==============================================================================
# 11. Update Shortcuts
# ==============================================================================
function updateprofile {
    $bootstrapUrl = "https://raw.githubusercontent.com/chneau/dotfiles/master/bootstrap.ps1"
    Write-Host "Updating PowerShell profile from $bootstrapUrl..." -ForegroundColor Cyan
    Invoke-Expression (Invoke-RestMethod -Uri $bootstrapUrl -Headers @{ 'Cache-Control' = 'no-cache' })
}
function updatebashrc { updateprofile }
function up { updateprofile }
function refresh {
    Write-Host "Reloading PowerShell profile..." -ForegroundColor Green
    if (Test-Path $PROFILE) { . $PROFILE }
}
