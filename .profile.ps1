# PowerShell Dotfiles & Aliases for Windows
# Compatible with Windows PowerShell 5.1 and PowerShell 7+ (pwsh)

# ==============================================================================
# 0. Shell Configuration & Built-in Conflict Resolution
# ==============================================================================

# Ensure UTF-8 output encoding
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# Remove built-in aliases that conflict with standard CLI utilities
$conflicts = @('curl', 'wget', 'diff', 'cp', 'rm', 'ls', 'sc', 'mv', 'cat', 'gc', 'gp', 'gl', 'ga', 'h', 'measure')
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


# ==============================================================================
# 3. Navigation
# ==============================================================================

# ==============================================================================
# 4. General CLI & File System
# ==============================================================================




function mkcdir($dir) {
    if (-not $dir) { Write-Error "Usage: mkcdir <directory>"; return }
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    Set-Location $dir
}


# --- Aliases mirrored from .aliases: navigation-free helpers -------------------


# Run a single command with BUN_CONFIG_VERBOSE_FETCH=curl, then restore it.



function psg([string]$pattern) {
    if (-not $pattern) { Write-Error "Usage: psg <pattern>"; return }
    Get-Process | Where-Object { $_.Name -match $pattern -or $_.Path -match $pattern }
}




# Align whitespace-separated columns, like `column -t`.


function findfile([string]$pattern) {
    if (-not $pattern) { Write-Error "Usage: findfile <pattern>"; return }
    Get-ChildItem -Recurse -File -Force -Filter $pattern
}


# Load .env into the current session (bash: set -o allexport; source .env).



# Upload a file, directory (zipped) or piped stdin to litterbox (72h).
# `... | transfer name.txt` uploads the pipeline content under name.txt.

# ==============================================================================
# 5. Git Shortcuts
# ==============================================================================
function gcamp($message) {
    if (-not $message) { Write-Error "Usage: gcamp <message>"; return }
    git commit -a -m "$message"
    if ($LASTEXITCODE -eq 0) { git push }
}
function gsp($message) {
    if (-not $message) { Write-Error "Usage: gsp <message>"; return }
    git add -A
    if ($LASTEXITCODE -ne 0) { return }
    git commit -m "$message"
    if ($LASTEXITCODE -eq 0) { git push }
}
function gpcb($target) {
    if (-not $target) { Write-Error "Usage: gpcb <target-branch>"; return }
    $curBranch = git branch --show-current
    git push origin "${curBranch}:${target}"
}
# Remove worktrees of the current repo. MODE 'safe' only drops worktrees whose
# HEAD is already merged into the default branch and that have no local changes,
# so no work of a still-active tree is lost. MODE 'force' drops every worktree
# except the one we are in.
function _GitcleanWorktrees([string]$Mode, [string]$Default) {
    $top = git rev-parse --show-toplevel 2>$null
    $entries = @()
    $entry = $null
    foreach ($line in (git worktree list --porcelain)) {
        if ($line -like 'worktree *') {
            if ($entry) { $entries += $entry }
            $entry = [pscustomobject]@{ Path = $line.Substring(9); Head = $null; Branch = $null }
        } elseif ($line -like 'HEAD *') { $entry.Head = $line.Substring(5) }
        elseif ($line -like 'branch refs/heads/*') { $entry.Branch = $line.Substring(18) }
        elseif ($line -eq 'detached') { $entry.Branch = $null }
    }
    if ($entry) { $entries += $entry }

    foreach ($e in $entries) {
        if (-not $e.Path -or ($e.Path -eq $top)) { continue }
        $label = if ($e.Branch) { " ($($e.Branch))" } else { "" }
        if ($Mode -eq 'force') {
            Write-Host "gitclean: removing worktree '$($e.Path)'$label"
            git worktree remove --force $e.Path
            if ($LASTEXITCODE -ne 0) { Write-Host "gitclean: could not remove '$($e.Path)'" }
        } else {
            if (-not $Default) { continue }
            git merge-base --is-ancestor $e.Head $Default 2>$null
            if ($LASTEXITCODE -ne 0) { continue }
            if (git -C $e.Path status --porcelain 2>$null) { continue }
            Write-Host "gitclean: removing merged worktree '$($e.Path)'$label"
            git worktree remove $e.Path
            if ($LASTEXITCODE -ne 0) { Write-Host "gitclean: could not remove '$($e.Path)'" }
        }
    }
    git worktree prune
}

function _Gitclean([string]$Mode) {
    # Drop tags that only exist locally (never pushed, or deleted on the remote)
    $remote = if (git remote | Where-Object { $_ -eq 'origin' }) { 'origin' } else { git remote | Select-Object -First 1 }
    if ($remote) {
        $remoteTags = git ls-remote --tags --refs $remote 2>$null
        if ($LASTEXITCODE -eq 0) {
            $remoteTags = $remoteTags | ForEach-Object { ($_ -split 'refs/tags/')[-1] }
            git tag | Where-Object { $remoteTags -notcontains $_ } | ForEach-Object {
                Write-Host "gitclean: removing local-only tag '$_'"
                git tag -d $_
            }
        }
    }

    git fetch --prune --prune-tags

    # Everything is compared against the default branch: origin/HEAD, else
    # origin/main or origin/master, else the local HEAD.
    $default = $null
    if ($remote) {
        $default = git symbolic-ref --quiet --short "refs/remotes/$remote/HEAD" 2>$null
        if (-not $default) {
            foreach ($candidate in @("$remote/main", "$remote/master")) {
                git show-ref --verify --quiet "refs/remotes/$candidate" 2>$null
                if ($LASTEXITCODE -eq 0) { $default = $candidate; break }
            }
        }
    }
    if (-not $default) { $default = git symbolic-ref --quiet --short HEAD 2>$null }

    _GitcleanWorktrees $Mode $default

    # Drop local-only branches that carry no work of their own (nothing beyond the
    # default branch). Branches still checked out in a surviving worktree are kept.
    if ($remote -and $default) {
        $current = git symbolic-ref --quiet --short HEAD 2>$null
        $top = git rev-parse --show-toplevel 2>$null
        $worktrees = @{}
        $worktree = $null
        foreach ($line in (git worktree list --porcelain)) {
            if ($line -like 'worktree *') { $worktree = $line.Substring(9) }
            elseif ($line -like 'branch refs/heads/*') { $worktrees[$line.Substring(18)] = $worktree }
        }
        foreach ($name in (git for-each-ref --format='%(refname:short)' refs/heads)) {
            if ($name -eq $current) { continue }
            git show-ref --verify --quiet "refs/remotes/$remote/$name" 2>$null
            if ($LASTEXITCODE -eq 0) { continue }
            if ((git rev-list --count "$default..$name") -ne 0) { continue }
            $pin = $worktrees[$name]
            if ($pin -and ($pin -ne $top)) {
                Write-Host "gitclean: keeping branch '$name' (still checked out in '$pin')"
                continue
            }
            Write-Host "gitclean: removing local-only branch '$name'"
            git branch -D $name
        }
    }

    git reflog expire --expire=now --all
    git repack -ad
    git prune

    git clean -ffdx
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

function goget([string]$pkg) {
    if (-not $pkg) { Write-Error "Usage: goget <pkg>"; return }
    go get -u -v ($pkg -replace '^.*://', '')
}




# Run gitclean in every nested repository (up to $Depth levels below the cwd).
function gitcleanr([int]$Depth = 1) {
    Get-ChildItem -Directory -Force -Recurse -Depth $Depth |
        Where-Object { Test-Path (Join-Path $_.FullName '.git') } |
        ForEach-Object {
            Write-Host "=== Cleaning $($_.FullName) ==="
            Push-Location $_.FullName
            try { gitclean } finally { Pop-Location }
        }
}

# ==============================================================================
# 6. Docker & Kubernetes
# ==============================================================================

# Docker needs forward slashes in volume paths; Windows paths use backslashes.
function _DockerPath([string]$Path = $PWD.Path) { $Path -replace '\\', '/' }



function dsave($image) {
    if (-not $image) { Write-Error "Usage: dsave <image>"; return }
    docker save $image -o "$image.tar"
    if ($LASTEXITCODE -ne 0) { return }
    gzip -f "$image.tar"
    if ($LASTEXITCODE -eq 0) { Write-Host "$image.tgz created" }
}


# List all tags for a Docker image on a remote registry.
function dockertags([string]$image, [string]$filter) {
    if (-not $image) {
        @'
dockertags  --  list all tags for a Docker image on a remote registry.

EXAMPLE:
    - list all tags for ubuntu:
       dockertags ubuntu

    - list all php tags containing apache:
       dockertags php apache
'@
        return
    }
    if ($image -notmatch '/') { $image = "library/$image" }
    $tags = (Invoke-RestMethod "https://hub.docker.com/v2/repositories/$image/tags?page_size=100").results.name
    if ($filter) { $tags = $tags | Where-Object { $_ -match $filter } }
    $tags
}

# Kubernetes


function kdecode($name) {
    if (-not $name) { Write-Error "Usage: kdecode <secret>"; return }
    $secret = kubectl get secret $name -o json | ConvertFrom-Json
    foreach ($prop in $secret.data.PSObject.Properties) {
        $value = [System.Text.Encoding]::UTF8.GetString(
            [Convert]::FromBase64String($prop.Value))
        "{0}: {1}" -f $prop.Name, $value
    }
}




function ktest([string]$image, [Parameter(ValueFromRemainingArguments = $true)]$rest) {
    if (-not $image) { Write-Error "Usage: ktest <image> [command...]"; return }
    kubectl run -i --tty --rm debug --image=$image --restart=Never -- @rest
}

# ==============================================================================
# 7. Language Tools & Runtimes (Bun, Node, Go, Python/uv, DotNet, Zig, Rust)
# ==============================================================================

# Bun

# Node & NPM

# Go
function goinst($pkg) {
    if (-not $pkg) { Write-Error "Usage: goinst <pkg>"; return }
    $clean = $pkg -replace '^.*://', ''
    go install "${clean}@latest"
}

# Python & uv

# .NET
function dotneti($tool) {
    if (-not $tool) { Write-Error "Usage: dotneti <tool>"; return }
    dotnet tool install --global $tool
    if ($LASTEXITCODE -ne 0) { dotnet tool update --global $tool }
}

# Zig

# Scaffolding

# nodemon with an extension filter (bash: nx ext cmd...)
function nx([string]$ext, [Parameter(ValueFromRemainingArguments = $true)]$cmd) {
    if (-not $ext -or -not $cmd) { Write-Error "Usage: nx <ext> <command...>"; return }
    nodemon --signal SIGTERM --ext $ext --exec "$($cmd -join ' ') || false"
}

# Terraform & Vagrant


# Installer shortcuts that run natively on Windows


# ==============================================================================
# 8. AI Coding Assistants & CLI Tools
# ==============================================================================
# ireasonix is also the update path: the built-in `reasonix upgrade` downloads a
# GitHub release tarball and fails with 404 while upstream lags on publishing it.





# ==============================================================================
# 9. Network & Web Utilities
# ==============================================================================
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


function h([Parameter(ValueFromRemainingArguments = $true)]$query) {
    curl.exe -s "https://cht.sh/$($query -join '/')"
    Write-Host
}

function portinuse([string]$port) {
    if (-not $port) { Write-Error "Usage: portinuse <port>"; return }
    Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue |
        Select-Object LocalAddress, LocalPort, State, OwningProcess,
            @{ n = 'Process'; e = { (Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue).ProcessName } }
}
function portkill([string]$port) {
    if (-not $port) { Write-Error "Usage: portkill <port>"; return }
    Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue |
        Select-Object -ExpandProperty OwningProcess -Unique |
        ForEach-Object { Stop-Process -Id $_ -Force -ErrorAction SilentlyContinue }
}

function serveo([string]$port) {
    if (-not $port) { Write-Error "Usage: serveo <port>"; return }
    ssh -o "StrictHostKeyChecking no" -R "80:localhost:$port" localhost.run
}


function traefikauth([string]$user, [string]$pass) {
    if (-not $user -or -not $pass) { Write-Error "Usage: traefikauth <user> <pass>"; return }
    (htpasswd -nb $user $pass) -replace '\$', '$$'
}

# --- Upload / share (bash: fio, pasteit, tb, topb, toqrcode) ------------------

# WSL helpers

# Fast Windows Activation / Utilities

# ==============================================================================
# 10. Media Utilities (yt-dlp)
# ==============================================================================

# ==============================================================================
# 11. Update Shortcuts
# ==============================================================================

# >>> generated aliases >>>
# [aliases]
function .. { Set-Location .. @args }
function ... { Set-Location ..\.. @args }
function .... { Set-Location ..\..\.. @args }
function a { ansible @args }
function agenty { agent --yolo @args }
function agyy { agy --dangerously-skip-permissions @args }
function ai-help { aihelp @args }
function aihelp { aihelp @args }
function b { bun @args }
function bbmd { bun build --metafile-md @args }
function bbx { bun --bun x @args }
function bcp { bun --cpu-prof-md @args }
function bcphp { bun --cpu-prof-md --heap-prof-md @args }
function bd { bun run dev @args }
function bench { hyperfine @args }
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
function bverbosefetch { BUN_CONFIG_VERBOSE_FETCH=curl  @args }
function bw { bun --watch --no-clear-screen @args }
function bx { bun x @args }
function bxb { bun --bun x @args }
function catfull { bat --style=full @args }
function cc { concurrently --prefix-colors=auto @args }
function cl { claude @args }
function cli-help { clihelp @args }
function clihelp { clihelp @args }
function cly { claude --dangerously-skip-permissions @args }
function codexy { codex --dangerously-bypass-approvals-and-sandbox @args }
function completeall { completeall @args }
function cpuinfo { lscpu @args }
function ct { column -t @args }
function curlt { curlt @args }
function d { docker @args }
function db { docker build --pull --tag @args }
function dbpush { docker build --pull --push --tag @args }
function dbtest { docker build --pull --tag test . @args }
function dc { docker compose @args }
function dcode { docker run --pull=always -p 127.0.0.1:8443:8443 -v "${PWD}:/root/project" codercom/code-server code-server --allow-http --no-auth @args }
function de { docker exec -it @args }
function df { df -Tha --total @args }
function dff { dfirefox @args }
function di { docker images @args }
function diff { diff --color -u -w @args }
function dir { dir --color=auto @args }
function diskspace { du @args }
function dl { docker logs --tail 40 -f @args }
function dlfast { lux -n 100 -m @args }
function dnd { docker run --rm -it --pull=always --name=netdata --pid=host --network=host -v netdataconfig:/etc/netdata -v netdatalib:/var/lib/netdata -v netdatacache:/var/cache/netdata -v /:/host/root:ro,rslave -v /etc/passwd:/host/etc/passwd:ro -v /etc/group:/host/etc/group:ro -v /etc/localtime:/etc/localtime:ro -v /proc:/host/proc:ro -v /sys:/host/sys:ro -v /etc/os-release:/host/etc/os-release:ro -v /var/log:/host/var/log:ro -v /var/run/docker.sock:/var/run/docker.sock:ro -v /run/dbus:/run/dbus:ro --cap-add SYS_PTRACE --cap-add SYS_ADMIN --security-opt apparmor=unconfined --no-healthcheck netdata/netdata @args }
function dndd { docker run --detach --pull=always --name=netdata --pid=host --network=host -v netdataconfig:/etc/netdata -v netdatalib:/var/lib/netdata -v netdatacache:/var/cache/netdata -v /:/host/root:ro,rslave -v /etc/passwd:/host/etc/passwd:ro -v /etc/group:/host/etc/group:ro -v /etc/localtime:/etc/localtime:ro -v /proc:/host/proc:ro -v /sys:/host/sys:ro -v /etc/os-release:/host/etc/os-release:ro -v /var/log:/host/var/log:ro -v /var/run/docker.sock:/var/run/docker.sock:ro -v /run/dbus:/run/dbus:ro --restart always --cap-add SYS_PTRACE --cap-add SYS_ADMIN --security-opt apparmor=unconfined --no-healthcheck netdata/netdata @args }
function dockertags { dockertags @args }
function dockerup { docker run --pull=always --rm -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower --cleanup --remove-volumes --debug --run-once @args }
function doh { docker history @args }
function dotnetfmt { dotnet csharpier . @args }
function dotnetup { dotnet outdated --upgrade @args }
function dsd { docker stack down @args }
function dsdf { docker system df @args }
function dsi { docker service inspect --pretty @args }
function dsl { docker service logs -f @args }
function dsls { docker service ls --tail 40 @args }
function dsu { docker stack up -c @args }
function dt { docker run --rm -it @args }
function dtest { docker run --rm -it --name test --hostname test @args }
function du { \du -chs * @args }
function dup { dockerup @args }
function dwatch { docker run --pull=always -d --restart=always --name=watchtower -v=/var/run/docker.sock:/var/run/docker.sock:ro containrrr/watchtower --cleanup --remove-volumes @args }
function e { Get-ChildItem -Force | Sort-Object Length -Descending | Select-Object -First 10 @args }
function egrep { grep -E @args }
function exportenv { ee @args }
function extract { extract @args }
function ff { free @args }
function fgrep { grep -F @args }
function findfile { find -type f -name @args }
function findtext { grep -rnw . -e @args }
function firewall { iptlist @args }
function fixgitbashbatfiles { fixgitbashbatfiles @args }
function fixionotify { fixinotify @args }
function fixionotifyinstances { fixinotifyinstances @args }
function fixionotifywatches { fixinotifywatches @args }
function fixtz { timedatectl set-timezone Europe/London @args }
function fixvpnipv4 { nmcli connection modify VPN_NAME ipv6.method disabled @args }
function fk { fkill --force @args }
function free { free -mt @args }
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
function genuuid { uv run python -c "import uuid; print(uuid.uuid4())" @args }
function gigit { git clone --depth=1 @args }
function gitclean { _Gitclean 'safe' @args }
function gitcleanf { _Gitclean 'force' @args }
function gitcleanr { gitcleanr @args }
function gitget { gitget @args }
function gitmessage { Write-Output (Invoke-RestMethod "https://whatthecommit.com/index.txt").Trim() @args }
function gitnewfresh { git checkout --orphan @args }
function gitrmtag { git push -d origin @args }
function gl { git pull @args }
function gla { git pull --all @args }
function glog { git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative @args }
function glom { git pull origin master @args }
function gobuild { CGO_ENABLED=0 go build -trimpath -ldflags '-s -w -extldflags \"-static\"' @args }
function goi { go install @args }
function gotest { go test -cover -count=1 @args }
function gotestfast { go test -v ./... @args }
function gp { git push @args }
function gpgexport { gpg --armor --export @args }
function gpggit { git config --global user.signingkey @args }
function gpglist { gpg --list-secret-keys --keyid-format LONG @args }
function gpgnew { gpg --default-new-key-algo rsa4096 --gen-key @args }
function gr { grep -C5 @args }
function grba { git rebase --abort @args }
function grbc { git rebase --continue @args }
function grep { grep --color=auto @args }
function grephere { grep -rnw . -e @args }
function gs { git status -sb @args }
function gsc { git switch -c @args }
function gsta { git stash push @args }
function gstd { git stash drop @args }
function gstl { git stash list @args }
function gstp { git stash pop @args }
function gsw { git switch @args }
function gundopush { git push -f origin HEAD^:master @args }
function hermesy { hermes --yolo @args }
function hf { hyperfine @args }
function hla { helm list --all-namespaces @args }
function hs { Get-History | Select-String @args }
function iagy { powershell -c "irm https://antigravity.google/cli/install.ps1 | iex" @args }
function ibombardier { go install github.com/codesenberg/bombardier@latest @args }
function ibpytop { uv tool install --force bpytop @args }
function ibun { powershell -c "irm bun.sh/install.ps1 | iex" @args }
function iccusage { bun i -g ccusage@latest @args }
function icf { bun i -g cf @args }
function icharlie { bun i -g charlie-git@latest @args }
function iclaude { powershell -c "irm https://claude.ai/install.ps1 | iex" @args }
function icline { bun i -g cline @args }
function icodex { powershell -c "irm https://chatgpt.com/codex/install.ps1 | iex" @args }
function icolab { uv tool install --force google-colab-cli @args }
function icommandcode { bun i -g command-code@latest @args }
function icopilot { bun i -g @github/copilot@latest @args }
function icursor { powershell -c "irm https://cursor.com/install.ps1 | iex" @args }
function idatree { go install github.com/datreeio/datree@latest @args }
function ideepcode { bun i -g @vegamo/deepcode-cli@latest @args }
function idefendnot { irm https://dnot.sh/ | iex @args }
function ideno { powershell -c "irm https://deno.land/install.ps1 | iex" @args }
function idl { uv tool install --force yt-dlp @args }
function idoctl { brew install doctl @args }
function idsh { bun i -g @deepseek-ai/dsh@latest @args }
function ifail2ban { ifail2ban @args }
function ifreebuff { bun i -g freebuff@latest @args }
function igem { brew install ruby @args }
function igogg { go install github.com/habedi/gogg@latest @args }
function igotop { go install github.com/xxxserxxx/gotop/v4@latest @args }
function igotty { go install github.com/yudai/gotty@latest @args }
function igradle { 'org.gradle.console=plain' | Set-Content "$HOME/.gradle/gradle.properties" @args }
function igravitycli { iagy @args }
function iherdr { powershell -c "irm https://herdr.dev/install.ps1 | iex" @args }
function ihermes { powershell -c "irm https://hermes-agent.nousresearch.com/install.ps1 | iex" @args }
function ihey { go install github.com/rakyll/hey@latest @args }
function ijsdoc-scribe { bun i -g jsdoc-scribe@latest @args }
function ik3sup { go install github.com/alexellis/k3sup@latest @args }
function ik9s { go install github.com/derailed/k9s@latest @args }
function ikamal { gem install kamal @args }
function ikilo { powershell -c "irm https://kilo.ai/cli/install.ps1 | iex" @args }
function ikind { go install sigs.k8s.io/kind@latest @args }
function iknip { bun install --global knip@latest @args }
function ikubectx { go install github.com/ahmetb/kubectx/cmd/kubectx@latest @args }
function ikubens { go install github.com/ahmetb/kubectx/cmd/kubens@latest @args }
function ilazygit { go install github.com/jesseduffield/lazygit@latest @args }
function ilivereload { uv tool install --force livereload @args }
function ilux { go install github.com/iawia002/lux@latest @args }
function imas { irm https://massgrave.dev/get | iex @args }
function imcode { bun i -g @minimax-ai/code @args }
function iomp { bun install -g @oh-my-pi/pi-coding-agent @args }
function iopencode { powershell -c "irm https://opencode.ai/install.ps1 | iex" @args }
function ipandoc { brew install pandoc @args }
function ipaseo { bun install -g @getpaseo/cli@latest @args }
function ipi { powershell -c "irm https://pi.dev/install.ps1 | iex" @args }
function ipipx { brew install pipx @args }
function iposthogcli { bun i -g @posthog/cli@latest @args }
function iqwen { bun install -fg @qwen-code/qwen-code@latest @args }
function ireasonix { bun i -g reasonix@latest @args }
function irtk { powershell -c "irm https://raw.githubusercontent.com/rtk-ai/rtk/master/install.ps1 | iex" @args }
function iscc { go install github.com/boyter/scc/v4@latest @args }
function iserve { go install github.com/chneau/serve@latest @args }
function iskillsmattpocock { bunx skills add mattpocock/skills @args }
function issh { ssh-keygen -t rsa -b 2048 @args }
function istern { go install github.com/stern/stern@latest @args }
function ituios { powershell -c "irm https://raw.githubusercontent.com/Gaurav-Gosain/tuios/main/install.ps1 | iex" @args }
function iuv { powershell -c "irm https://astral.sh/uv/install.ps1 | iex" @args }
function ivpn { ivpnnyr @args }
function ix { bun install --force --global @chneau/x @args }
function k { kubectl @args }
function ka { kubectl apply -f @args }
function kak { kubectl apply -k @args }
function kar { kubectl api-resources @args }
function kconf { kubectl config view --raw @args }
function kcron { Write-Host "kubectl create job --from=cronjob/dump manual-001" @args }
function kctx { kubectx @args }
function kd { kubectl diff -f @args }
function kdebug { kubectl run -i --tty --rm debug --image=alpine --restart=Never -- sh @args }
function kdes { kubectl describe @args }
function kdestroy { kubectl delete --grace-period=0 --force @args }
function kdk { kubectl diff -k @args }
function kdn { kubectl describe node @args }
function ke { kubectl exec -ti @args }
function kenv { kubectl set env pods --all --list @args }
function kex { kubectl explain @args }
function kg { kubectl get @args }
function kga { kubectl get all,ingress @args }
function kgaa { kubectl get all,ingress --all-namespaces @args }
function kgapi { kubectl get apiservices @args }
function kgd { kubectl get deployment,statefulset,daemonset,cronjob @args }
function kge { kubectl get events @args }
function kgea { kubectl get events --all-namespaces @args }
function kgia { kubectl get ingress --all-namespaces @args }
function kgpa { kubectl get pods --all-namespaces @args }
function kgs { kubectl get secret @args }
function kiloy { kilo --auto @args }
function kk { kubectl kustomize @args }
function kkill { kubectl delete pods --grace-period=0 --force --all @args }
function kl { kubectl logs -f --tail=40 @args }
function klall { kubectl stern --max-log-requests=999 --since=1s @args }
function klall_old { kubectl logs --selector=pod-template-hash --all-containers --ignore-errors --follow --max-log-requests=999 --timestamps --prefix @args }
function klallall { kubectl stern --all-namespaces --max-log-requests=999 --since=1s @args }
function kll { kubectl logs -f --tail=40 --timestamps --prefix @args }
function kmip { kubectl run debug --stdin --tty --rm --image=alpine --restart=Never -- sh -ci "wget -qO- api.ipify.org && echo" @args }
function kns { kubens @args }
function knt { kubent @args }
function kpf { kubectl port-forward @args }
function kr { kubectl rollout @args }
function krr { kubectl rollout restart @args }
function ktn { kubectl top nodes @args }
function ktp { kubectl top pods --sort-by=memory @args }
function ktpa { kubectl top pods --all-namespaces --sort-by=memory @args }
function kw { kubectl get po -w @args }
function l { Get-ChildItem -Force @args }
function la { Get-ChildItem -Force @args }
function lg { lazygit @args }
function lh { Get-ChildItem -Force @args }
function ll { Get-ChildItem -Force @args }
function lld { ls -alFhtr --group-directories-first @args }
function lo { ls -o @args }
function ls { ls --color=auto @args }
function m { make @args }
function mapscii { telnet mapscii.me @args }
function meminfo { free @args }
function mh { Write-Output (Invoke-RestMethod "https://ifconfig.me/host").Trim() @args }
function mip2 { curl.exe -s4 https://icanhazip.com @args }
function mkdir { mkdir -pv @args }
function ncup { npm-check-updates --upgrade --install=always --packageManager=bun --deep @args }
function newfarm { bun create farm@latest @args }
function newrefine { bun create refine-app@latest @args }
function newrsbuild { bun create rsbuild@latest @args }
function newstorybook { npx storybook@latest init @args }
function newvite { bun create vite@latest @args }
function nload { nload -m -u M @args }
function now { Get-Date -Format "HH:mm:ss" @args }
function nowdate { Get-Date -Format "dd-MM-yyyy" @args }
function nowtime { now @args }
function npme { npm exec --yes -- @args }
function npmup { npm-check-updates --deep --upgrade --install=always --packageManager=bun @args }
function nud { nvm use default @args }
function oc { code -a . @args }
function ocy { opencode --auto @args }
function ompu { omp update @args }
function ompy { omp --auto-approve @args }
function opencodey { opencode --auto @args }
function openports { nmap -p- portquiz.net | Select-String -Pattern 'open' -CaseSensitive:$false @args }
function path { Write-Output ($env:PATH -split ';') @args }
function pipi { uv pip install --upgrade @args }
function pipig { uv tool install @args }
function pipup { uv pip install --upgrade @args }
function pipupg { uv tool upgrade --all @args }
function poefilterup { poefilterup @args }
function ports { netstat -ano @args }
function ps { ps auxf @args }
function pscpu { Get-Process | Sort-Object CPU -Descending @args }
function pscpu10 { Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 @args }
function psmem { Get-Process | Sort-Object WorkingSet64 -Descending @args }
function psmem10 { Get-Process | Sort-Object WorkingSet64 -Descending | Select-Object -First 10 @args }
function pstats { powerstat -d 0 -f 1 @args }
function reactdoctor { bunx react-doctor@latest @args }
function reasonixy { reasonix --permission-mode bypassPermissions @args }
function refreshgroups { exec sudo su -l $USER @args }
function root { \sudo \su @args }
function rw { reasonix web @args }
function ry { reasonix --permission-mode bypassPermissions --yolo @args }
function ryp { reasonix -p --permission-mode bypassPermissions --add-dir "$HOME" --add-dir /tmp @args }
function s { strace -fqc @args }
function screen { screen -q @args }
function servepy { uv run python -m http.server @args }
function sshkillagents { ssh-add -D @args }
function t { tmux @args }
function ta { tmux a @args }
function tb { nc termbin.com 9999 @args }
function tf { terraform @args }
function tmux-help { tmuxhelp @args }
function tmuxhelp { tmuxhelp @args }
function topb { curl -F 'file=@-' 0x0.st @args }
function toqrcode { curl -F-=\<- qrenco.de @args }
function transfer { transfer @args }
function tsfmt { biome check --write --unsafe . @args }
function tslint { tsc --noEmit --project . @args }
function u { ls -hltr @args }
function up { updateprofile @args }
function upb { updateprofile; refresh @args }
function updatebashrc { updateprofile @args }
function upload-help { uploadhelp @args }
function uploadhelp { uploadhelp @args }
function va { vagrant @args }
function vdir { vdir --color=auto @args }
function webshare { uv run python -m http.server @args }
function ymp3 { yt-dlp --restrict-filenames --continue --ignore-errors --download-archive downloaded.txt --no-post-overwrites --no-overwrites --extract-audio --audio-format mp3 --output "%(title)s.%(ext)s"' # --min-views --match-filter '!is_live @args }
function ymp4 { yt-dlp -S res,ext:mp4:m4a --recode mp4 @args }
function ymp4s { yt-dlp -S res,ext:mp4:m4a --recode mp4 --embed-subs --sub-lang en --add-metadata --convert-subs srt --embed-thumbnail @args }
function yt { yt-dlp @args }
function z { zig @args }
function zb { zig build @args }
function zbr { zig build run @args }
function ziup { zi update --all --parallel @args }
function zr { zig run @args }
function aihelp {
    @"
AI CLI Tools & Assistants (Windows / PowerShell)
================================================

Tool       Provider / Vendor       Aliases                 Description
----       -----------------       -------                 -----------
claude     Anthropic               cl, cly                 Claude AI coding assistant & agent
cline      Cline                   -                       Cline AI coding agent (YOLO by default in CLI)
agy        Google DeepMind         agyy                    Antigravity agentic coding assistant CLI
agent      Cursor / Anysphere      agenty                  Cursor AI terminal agent & CLI
codex      OpenAI                  codexy                  ChatGPT / Codex terminal coding agent
copilot    GitHub / Microsoft      -                       GitHub Copilot CLI for terminal assistance
qwen       Alibaba Cloud           -                       Qwen Code terminal coding assistant
mcode      MiniMax                 -                       MiniMax Code coding agent CLI
reasonix   Reasonix AI             ry, reasonixy, rw       Reasoning AI assistant CLI & web UI
opencode   OpenCode AI             ocy, opencodey          Multi-provider open-source coding assistant
deepcode   Vegamo                  -                       DeepCode terminal AI assistant
commandcode Command Code           -                       Coding agent that learns your coding taste
kilo       Kilo AI                 kiloy                   Kilo AI coding agent CLI (run w/ --auto)
hermes     Nous Research           hermesy                 Hermes agentic coding assistant CLI
dsh        DeepSeek                -                       DeepSeek shell / coding assistant CLI
pi         Pi                       -                       Pi coding agent CLI
omp        Oh My Pi                ompy, ompu              Oh My Pi coding agent CLI (run w/ --auto-approve; update w/ ompu)
reactdoctor React Doctor           -                       AI-powered React code diagnostics (bunx react-doctor@latest)
rtk        RTK AI                  -                       RTK AI developer toolkit CLI
freebuff   Codebuff                -                       Free Codebuff coding agent
paseo      Paseo                   -                       Paseo CLI to control AI coding agents from the terminal

Install / Update Aliases:
  iclaude      Install Claude CLI
  icline       Install Cline CLI
  icolab       Install Google Colab CLI
  icf          Install Cloudflare cf CLI
  icharlie     Install Charlie Git CLI
  igravitycli  Install Antigravity CLI
  iagy         Install Antigravity CLI (short)
  icodex       Install OpenAI Codex CLI
  icopilot     Install GitHub Copilot CLI
  icursor      Install Cursor CLI
  iqwen        Install Qwen Code CLI
  ireasonix    Install / update Reasonix CLI
  iopencode    Install OpenCode CLI
  ideepcode    Install DeepCode CLI
  irtk         Install RTK CLI
  ipi          Install Pi CLI
  iomp         Install Oh My Pi CLI
  ompu         Update Oh My Pi CLI
  imcode       Install MiniMax Code CLI
  idsh         Install DeepSeek dsh CLI
  iposthogcli  Install PostHog CLI
  ifreebuff    Install freebuff CLI
  icommandcode Install command-code CLI
  ikilo        Install Kilo CLI
  ihermes      Install Hermes CLI
  iskillsmattpocock  Install mattpocock skills CLI
  iccusage     Install ccusage CLI
  iherdr       Install Herdr CLI
  ituios       Install tuios CLI
  ipaseo       Install / update Paseo CLI

Useful Prompts:
  Codebase Refactor:
    Look through my codebase for opportunities to refactor and simplify, and suggest the highest-impact ones.
  Code Simplification:
    Refactor this code to eliminate redundancy and improve readability and maintainability.
  Test Coverage:
    Analyze my test coverage and tell me where adding tests would have the most impact.
  Security Audit:
    Review this codebase for security vulnerabilities, injection risks, and sensitive data exposure.
  Strict Code Review:
    Review my recent changes like a senior engineer. Flag regressions, edge cases, and architectural smells.
  Performance Bottlenecks:
    Profile this logic and identify the primary performance or memory bottlenecks with concrete optimizations.
  Database Optimization:
    Analyze these database queries/schemas for missing indexes, N+1 issues, and slow operations.
  Root Cause Analysis:
    Diagnose this failure, determine the root cause, and propose the minimal fix to prevent recurrence.
  Edge Case Discovery:
    Identify unhandled edge cases, failure modes, and concurrency issues in this implementation.
  Architecture Check:
    Critique the current design against SOLID/DRY principles and recommend cleaner abstractions without overengineering.
  API Ergonomics:
    Review this API/interface for ergonomics, consistency, idiomatic design, and ease of use.
  Missing Docs:
    Identify critical undocumented assumptions, setup steps, and failure modes across this project.
  Log Analysis:
    Analyze these logs to identify errors, warnings, recurring anomalies, and their potential root causes.
  UX Flow Audit:
    Walk through this feature's user journey step by step and flag friction, dead ends, and unnecessary steps.
  Friction Reduction:
    Find where users will hesitate, get confused, or abandon this flow, and propose the smallest changes that reduce friction.
  Onboarding Review:
    Evaluate the first-run experience and remove anything that delays a new user from reaching value.
  Empty States:
    Design helpful empty, loading, and error states so users always know what is happening and what to do next.
  Error Recovery:
    Review these error messages and failure flows for clarity and actionable recovery paths.
  Microcopy:
    Rewrite these labels, buttons, and helper texts for clarity, consistency, and tone.
  Navigation & IA:
    Assess this navigation and information architecture so users can predict where things live.
  Feedback & Responsiveness:
    Ensure every action gives timely, clear feedback for loading, success, and failure.
  Accessibility Pass:
    Review this UI for input, contrast, focus, and feedback issues that block users.
  Cross-Device Flow:
    Check this flow on mobile and keyboard-only use, and flag where it breaks or degrades.
  State Consistency:
    Audit this flow for inconsistent labels, state transitions, and feedback across screens.
  Progressive Disclosure:
    Identify where this interface overwhelms users and what should be hidden until it is needed.
  UX Heuristic Review:
    Critique this interface against Nielsen's usability heuristics and rank the top fixes by impact.
"@
}
function bverbosefetch {
    if (-not $args) { Write-Error "Usage: bverbosefetch <command> [args...]"; return }
    $previous = $env:BUN_CONFIG_VERBOSE_FETCH
    $env:BUN_CONFIG_VERBOSE_FETCH = 'curl'
    try {
        $command = $args[0]
        $rest = @()
        if ($args.Count -gt 1) { $rest = @($args[1..($args.Count - 1)]) }
        & $command @rest
    } finally {
        $env:BUN_CONFIG_VERBOSE_FETCH = $previous
    }
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
  transfer   Catbox / Litterbox file sharing
  pasteit    paste.rs pastebin
  tb         termbin.com pastebin
  topb       0x0.st pastebin
  weather    wttr.in weather lookup
  curlt      HTTP request timing inspection
"@
}
function cpuinfo {
    Get-CimInstance Win32_Processor |
        Select-Object Name, NumberOfCores, NumberOfLogicalProcessors, MaxClockSpeed
}
function ct {
    $rows = @()
    foreach ($line in @($input)) {
        foreach ($part in ($line -split "`r?`n")) {
            if (-not $part -or $part -match '^\s*$') { continue }
            $rows += , @($part.Trim() -split '\s+')
        }
    }
    if ($rows.Count -eq 0) { return }
    $widths = @{}
    foreach ($r in $rows) {
        for ($i = 0; $i -lt $r.Count; $i++) {
            if ($r[$i].Length -gt $widths[$i]) { $widths[$i] = $r[$i].Length }
        }
    }
    foreach ($r in $rows) {
        $cells = for ($i = 0; $i -lt $r.Count; $i++) { $r[$i].PadRight($widths[$i]) }
        ($cells -join ' ').TrimEnd()
    }
}
function dc9router {
    $json = @"
{"services":{"9router":{"image":"decolua/9router:latest","ports":["20128:20128"],"volumes":["$(_DockerPath $HOME)/.9router:/app/data"],"environment":{"DATA_DIR":"/app/data","HEADROOM_URL":"http://headroom:8787"},"depends_on":["headroom"]},"headroom":{"image":"ghcr.io/chopratejas/headroom:latest","ports":["8787:8787"]}}}
"@
    $composeFile = Join-Path ([System.IO.Path]::GetTempPath()) 'dotfiles-9router.compose.json'
    [System.IO.File]::WriteAllText($composeFile, $json, (New-Object System.Text.UTF8Encoding($false)))
    docker compose -f $composeFile up -d
}
function dc9routerup {
    docker pull decolua/9router:latest
    docker pull ghcr.io/chopratejas/headroom:latest
    dc9router
}
function dcb {
    Write-Host "http://localhost:8978/"
    docker run --name cloudbeaver --rm -it -p 8978:8978 -v "$(_DockerPath $HOME)/.cache/cloudbeaver:/opt/cloudbeaver/workspace" dbeaver/cloudbeaver:latest
}
function dcode {
    docker run --pull=always -p 127.0.0.1:8443:8443 -v "$(_DockerPath):/root/project" codercom/code-server code-server --allow-http --no-auth
}
function dcps {
    $out = docker compose ps @args
    if (Get-Command docker-color-output -ErrorAction SilentlyContinue) { $out | docker-color-output } else { $out }
}
function ddown {
    $running = docker ps -a -q
    if ($running) { docker stop $running }
}
function df {
    Get-PSDrive -PSProvider FileSystem | ForEach-Object {
        $total = $_.Used + $_.Free
        [pscustomobject]@{
            Name    = $_.Name
            TotalGB = if ($total) { [math]::Round($total / 1GB, 1) } else { 0 }
            UsedGB  = if ($_.Used) { [math]::Round($_.Used / 1GB, 1) } else { 0 }
            FreeGB  = if ($_.Free) { [math]::Round($_.Free / 1GB, 1) } else { 0 }
            Root    = $_.Root
        }
    }
}
function dfirefox {
    Write-Host "https://c:c@$(curl.exe -s4 https://ifconfig.co):3001"
    docker run --pull=always --rm --name=ff --net=host --security-opt=seccomp=unconfined --shm-size=4gb --env=TZ=Europe/London --env=PUID=1000 --env=PGID=1000 --env=CUSTOM_USER=c --env=PASSWORD=c -v="$(_DockerPath $HOME)/docker/firefox:/config" lscr.io/linuxserver/firefox
}
function diff {
    if (Get-Command diff.exe -ErrorAction SilentlyContinue) {
        & diff.exe -u -w @args
    } elseif (Get-Command git.exe -ErrorAction SilentlyContinue) {
        & git.exe diff --no-index @args
    } else {
        Compare-Object @args
    }
}
function djellyfin {
    Write-Host "http://$(curl.exe -s4 https://ifconfig.co):8096"
    New-Item -ItemType Directory -Force -Path "$HOME/docker/jellyfin/config", "$HOME/docker/jellyfin/cache", "$HOME/docker/jellyfin/media" | Out-Null
    docker run --pull always --rm -it --name jellyfin --user 1000:1000 --net host --volume "$(_DockerPath $HOME)/docker/jellyfin/config:/config" --volume "$(_DockerPath $HOME)/docker/jellyfin/cache:/cache" --volume "$(_DockerPath $HOME)/docker/jellyfin/media:/media" jellyfin/jellyfin
}
function dk {
    docker run --pull=always --rm -it --name=kaggle -p=8080:8080 -v="$(_DockerPath):$(_DockerPath)" -w="$(_DockerPath)" kaggle/python jupyter notebook --no-browser --notebook-dir="$(_DockerPath)" --allow-root --port=8080 --ip=*
}
function dkill {
    $running = docker ps -q
    if ($running) { docker kill $running }
}
function dkilla {
    $running = docker ps -a -q
    if ($running) { docker stop $running }
}
function dlog {
    $ids = @(docker ps -q)
    if (-not $ids) { return }
    if ($PSVersionTable.PSVersion.Major -ge 7) {
        $ids | ForEach-Object -Parallel { docker logs --since 30s -f $_ }
    } else {
        $ids | ForEach-Object { docker logs --since 30s -f $_ }
    }
}
function dm {
    docker run --pull=always --net=host --rm -itv "$(_DockerPath):$(_DockerPath)" -w "$(_DockerPath)" -u 1000 mongo
}
function dn {
    docker run --pull=always --rm -itv "$(_DockerPath):$(_DockerPath)" -w "$(_DockerPath)" -u 1000 node:alpine
}
function dnd {
    docker run --rm -it --pull=always --name=netdata --pid=host --network=host -v netdataconfig:/etc/netdata -v netdatalib:/var/lib/netdata -v netdatacache:/var/cache/netdata -v /:/host/root:ro,rslave -v /etc/passwd:/host/etc/passwd:ro -v /etc/group:/host/etc/group:ro -v /etc/localtime:/etc/localtime:ro -v /proc:/host/proc:ro -v /sys:/host/sys:ro -v /etc/os-release:/host/etc/os-release:ro -v /var/log:/host/var/log:ro -v /var/run/docker.sock:/var/run/docker.sock:ro -v /run/dbus:/run/dbus:ro --cap-add SYS_PTRACE --cap-add SYS_ADMIN --security-opt apparmor=unconfined --no-healthcheck netdata/netdata
}
function dndd {
    docker run --detach --pull=always --name=netdata --pid=host --network=host -v netdataconfig:/etc/netdata -v netdatalib:/var/lib/netdata -v netdatacache:/var/cache/netdata -v /:/host/root:ro,rslave -v /etc/passwd:/host/etc/passwd:ro -v /etc/group:/host/etc/group:ro -v /etc/localtime:/etc/localtime:ro -v /proc:/host/proc:ro -v /sys:/host/sys:ro -v /etc/os-release:/host/etc/os-release:ro -v /var/log:/host/var/log:ro -v /var/run/docker.sock:/var/run/docker.sock:ro -v /run/dbus:/run/dbus:ro --restart always --cap-add SYS_PTRACE --cap-add SYS_ADMIN --security-opt apparmor=unconfined --no-healthcheck netdata/netdata
}
function dnekoff {
    Write-Host "http://$(curl.exe -s4 https://ifconfig.co):8080"
    docker run --pull=always --rm -it --name=neko --shm-size=2gb --net=host --env=NEKO_DESKTOP_SCREEN=1920x1080@30 --env=NEKO_MEMBER_MULTIUSER_USER_PASSWORD=c --env=NEKO_MEMBER_MULTIUSER_ADMIN_PASSWORD=cc --env=NEKO_WEBRTC_EPR=52000-52100 --env=NEKO_WEBRTC_ICELITE=1 ghcr.io/m1k1o/neko/firefox
}
function dockerup {
    docker run --pull=always --rm -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower --cleanup --remove-volumes --debug --run-once
}
function dotnethttps {
    dotnet dev-certs https --clean
    dotnet dev-certs https --trust
}
function dotnetig {
    $tools = @('dotnet-outdated-tool', 'Roslynator.DotNet.Cli', 'dotnet-ef', 'dotnet-serve', 'PowerShell', 'CSharpier', 'CentralisedPackageConverter', 'dotnet-symbol')
    foreach ($t in $tools) { dotneti $t }
}
function dpihole {
    docker run --pull=always -d --name pihole -p 53:53/tcp -p 53:53/udp -p 1080:80 -e TZ="Europe/London" -v "$(_DockerPath)/pihole/etc/pihole/:/etc/pihole/" -v "$(_DockerPath)/pihole/etc/dnsmasq.d/:/etc/dnsmasq.d/" --dns=127.0.0.1 --dns=1.1.1.1 --restart=unless-stopped --hostname pihole -e VIRTUAL_HOST="pihole" -e PROXY_LOCATION="pihole" -e ServerIP="127.0.0.1" pihole/pihole:latest
}
function dprune {
    docker system prune --force --volumes
    docker volume prune --force
}
function dprunea {
    docker system prune --force --volumes --all
    docker volume prune --force --all
}
function dps {
    $out = docker ps @args
    if (Get-Command docker-color-output -ErrorAction SilentlyContinue) { $out | docker-color-output } else { $out }
}
function drm {
    $dangling = docker images -q --filter "dangling=true"
    if ($dangling) { docker rmi $dangling }
}
function ds {
    $out = docker stats @args
    if (Get-Command docker-color-output -ErrorAction SilentlyContinue) { $out | docker-color-output } else { $out }
}
function dtf {
    docker run --pull=always --rm -it --name=kaggle -p=8080:8080 -v="$(_DockerPath):$(_DockerPath)" -w="$(_DockerPath)" tensorflow/tensorflow jupyter notebook --no-browser --notebook-dir="$(_DockerPath)" --allow-root --port=8080 --ip=*
}
function du {
    Get-ChildItem -Force @args | ForEach-Object {
        $size = if ($_.PSIsContainer) {
            (Get-ChildItem -Recurse -Force -File $_.FullName -ErrorAction SilentlyContinue |
                Measure-Object Length -Sum).Sum
        } else { $_.Length }
        [pscustomobject]@{ Size = [long]$size; Name = $_.Name }
    } | Sort-Object Size -Descending |
        Select-Object @{ n = 'MB'; e = { [math]::Round($_.Size / 1MB, 2) } }, Size, Name
}
function dwatch {
    docker run --pull=always -d --restart=always --name=watchtower -v=/var/run/docker.sock:/var/run/docker.sock:ro containrrr/watchtower --cleanup --remove-volumes
}
function ee {
    if (-not (Test-Path .env)) { Write-Error "ee: .env not found"; return }
    foreach ($line in Get-Content .env) {
        if ($line -match '^\s*#' -or $line -notmatch '=') { continue }
        $name, $value = $line -split '=', 2
        Set-Item -Path "Env:$($name.Trim())" -Value $value.Trim()
    }
}
function extract {
    if (-not $args) {
        Write-Host "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
        return
    }
    foreach ($n in $args) {
        if (-not (Test-Path -LiteralPath $n)) { Write-Host "'$n' - file does not exist"; return }
        switch -Regex ($n) {
            '\.(tar\.bz2|tar\.gz|tar\.xz|tbz2|tgz|txz|tar)$' { tar xvf $n; break }
            '\.(zip|arj|cab|chm|deb|dmg|iso|lzh|msi|rpm|udf|wim|xar|7z)$' { 7z x $n; break }
            '\.exe$' { cabextract $n; break }
            '\.xz$' { unxz $n; break }
            '\.gz$' { gunzip $n; break }
            '\.bz2$' { bunzip2 $n; break }
            '\.rar$' { unrar x -ad $n; break }
            '\.lzma$' { unlzma $n; break }
            default { Write-Host "extract: '$n' - unknown archive method"; return }
        }
    }
}
function fio {
    if (-not $args) { Write-Error "Usage: fio <file>"; return }
    curl.exe -F "file=@$($args[0])" https://file.io
    Write-Host
}
function fio1 {
    if (-not $args) { Write-Error "Usage: fio1 <file>"; return }
    curl.exe -F "file=@$($args[0])" "https://file.io/?expires=1d"
    Write-Host
}
function free {
    $os = Get-CimInstance Win32_OperatingSystem
    [pscustomobject]@{
        TotalMB = [math]::Round($os.TotalVisibleMemorySize / 1024)
        UsedMB  = [math]::Round(($os.TotalVisibleMemorySize - $os.FreePhysicalMemory) / 1024)
        FreeMB  = [math]::Round($os.FreePhysicalMemory / 1024)
    }
}
function genpwd {
    $rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()
    $bytes = New-Object byte[] 32
    $rng.GetBytes($bytes)
    $password = [Convert]::ToBase64String($bytes)
    $password
    $hash = [System.Security.Cryptography.SHA256]::Create().ComputeHash(
        [System.Text.Encoding]::UTF8.GetBytes($password))
    $hex = -join ($hash | ForEach-Object { $_.ToString('x2') })
    $hex
    $hex.Substring(0, 16)
    $alpha = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
    -join (1..16 | ForEach-Object { $alpha[(Get-Random -Maximum $alpha.Length)] })
}
function gg {
    git pull -f
    $defaultBranch = if (& git show-ref --verify --quiet refs/remotes/origin/main) { "main" } else { "master" }
    git reset --hard "origin/$defaultBranch"
}
function glog {
    git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative @args
}
function gobuild {
    $env:CGO_ENABLED = "0"
    go build -trimpath -ldflags '-s -w' @args
}
function gols {
    $deps = go list -f '{{join .Deps "\n"}}'
    go list -f '{{if not .Standard}}{{.ImportPath}}{{end}}' @deps
}
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
function gpm {
    $curBranch = git branch --show-current
    git push origin "${curBranch}:master" @args
}
function grb {
    git fetch --all
    git for-each-ref --sort=-committerdate --format='%(HEAD) %(color:blue)%(authordate:iso) %(color:red)%(objectname:short) %(color:yellow)%(refname:short) %(color:reset)%(contents:subject) %(color:magenta)%(authorname) %(color:green)%(committerdate:relative)' refs
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
function grm {
    $deleted = git ls-files --deleted
    if ($deleted) { $deleted | ForEach-Object { git rm $_ } }
}
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
function iproxy {
    $alpha = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
    $login = -join (1..32 | ForEach-Object { $alpha[(Get-Random -Maximum $alpha.Length)] })
    $password = -join (1..32 | ForEach-Object { $alpha[(Get-Random -Maximum $alpha.Length)] })
    $env:PROXY_LOGIN = $login
    $env:PROXY_PASSWORD = $password
    $ip = (curl.exe -s4 https://ifconfig.co).Trim()
    Write-Host "Login: $login"
    Write-Host "Password: $password"
    Write-Host "HTTPS_PROXY=`"http://${login}:${password}@${ip}:3128/`""
    docker rm -f proxy 2>$null | Out-Null
    docker run --pull=always --rm -d -e PROXY_LOGIN -e PROXY_PASSWORD --name=proxy --net=host ghcr.io/tarampampam/3proxy:latest
}
function kclean {
    $replicas = kubectl get rs -o jsonpath="{range .items[?(@.spec.replicas==0)]}{.metadata.name}{' '}{end}"
    foreach ($name in ($replicas -split '\s+')) {
        if ($name) { kubectl delete rs $name }
    }
    kubectl delete pods --field-selector status.phase=Failed --ignore-not-found
    kubectl delete pods --field-selector status.phase=Succeeded --ignore-not-found
}
function krewig {
    kubectl krew install ns ctx stern
    kubectl krew upgrade
}
function ks0 {
    kubectl scale --replicas=0 deployment --all
    kubectl scale --replicas=0 statefulset --all
}
function ks1 {
    kubectl scale --replicas=1 deployment --all
    kubectl scale --replicas=1 statefulset --all
}
function lld {
    Get-ChildItem -Force |
        Sort-Object @{ e = { $_.PSIsContainer }; Descending = $true },
                    @{ e = { $_.LastWriteTime }; Descending = $true } |
        Format-Table Mode, LastWriteTime, Length, Name -AutoSize
}
function lo {
    Get-ChildItem -Force | Format-Table Mode, LastWriteTime, Length, Name -AutoSize
}
function ls {
    if (Get-Command ls.exe -ErrorAction SilentlyContinue) {
        & ls.exe --color=auto @args
    } else {
        Get-ChildItem @args
    }
}
function mip {
    if (Get-Command dig.exe -ErrorAction SilentlyContinue) {
        $out = dig.exe +short txt ch whoami.cloudflare '@1.0.0.1'
        if ($out) { $out; return }
    }
    curl.exe -s4 https://api.ipify.org
    Write-Host
}
function myip {
    try { (Invoke-RestMethod "https://icanhazip.com").Trim() }
    catch { (Invoke-RestMethod "https://api.ipify.org").Trim() }
}
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
function pasteit {
    if ($args) {
        curl.exe --data-binary "@$($args[0])" https://paste.rs
    } else {
        (@($input) -join "`n") | curl.exe --data-binary '@-' https://paste.rs
    }
    Write-Host
}
function prompt {
    $lastSuccess = $?
    $lastExit = $global:LASTEXITCODE

    # Exit icon & status code:
    # In PowerShell, internal cmdlets/functions set $? to $true/$false but do NOT reset $LASTEXITCODE.
    # So if $lastSuccess is $true, the last command succeeded.
    if ($lastSuccess) {
        $statusIcon = "$Green[OK]$Reset"
        $global:LASTEXITCODE = 0
    } else {
        $code = if ($null -ne $lastExit -and $lastExit -ne 0) { $lastExit } else { 1 }
        $statusIcon = "$Red[ERR:$code]$Reset"
    }

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

    $timeNow = Get-Date -Format "HH:mm:ss"
    $userHost = "$Green$env:USERNAME@$env:COMPUTERNAME$Reset"
    $currDir = "$Blue$(Get-Location)$Reset"

    $timerDisplay = if ($durationStr) { "($durationStr) " } else { "" }

    return "$statusIcon $timerDisplay$White$timeNow$Reset $userHost $currDir $Blue>$Reset "
}
function refresh {
    Write-Host "Reloading PowerShell profile..." -ForegroundColor Green
    if (Test-Path $PROFILE) { . $PROFILE }
}
function sshgenkey {
    New-Item -ItemType Directory -Force -Path .ssh | Out-Null
    ssh-keygen -t rsa -f .ssh/id_rsa -q --% -N ""
}
function stripcolors {
    $esc = [char]27
    foreach ($line in @($input)) { $line -replace "$esc\[[0-9;]{1,6}[mGK]", '' }
}
function tb {
    $client = New-Object System.Net.Sockets.TcpClient('termbin.com', 9999)
    try {
        $stream = $client.GetStream()
        $writer = New-Object System.IO.StreamWriter($stream)
        $writer.Write((@($input) -join "`n") + "`n")
        $writer.Flush()
        $reader = New-Object System.IO.StreamReader($stream)
        $reader.ReadToEnd().Trim()
    } finally {
        $client.Close()
    }
}
function tmuxhelp {
    @'
tmux Cheat Sheet & Basics
-------------------------
Default prefix key: Ctrl+b  (press Ctrl+b, release, then press key)

Sessions
  tmux                        Start a new session
  tmux new -s <name>          Start a new session named <name>
  tmux ls                     List existing sessions
  tmux a                      Attach to the last session
  tmux a -t <name>            Attach to session named <name>
  tmux kill-session -t <name> Kill a session by name
  tmux kill-server            Kill all tmux sessions and server
  Ctrl+b d                    Detach from current session
  Ctrl+b s                    Interactive session selector / list
  Ctrl+b $                    Rename current session

Windows (Tabs)
  Ctrl+b c                    Create a new window
  Ctrl+b ,                    Rename current window
  Ctrl+b w                    Interactive window / session list
  Ctrl+b n                    Switch to next window
  Ctrl+b p                    Switch to previous window
  Ctrl+b <0-9>                Switch to window by index
  Ctrl+b &                    Close current window

Panes (Splits)
  Ctrl+b %                    Split pane vertically (left / right)
  Ctrl+b "                    Split pane horizontally (top / bottom)
  Ctrl+b <arrows>             Navigate between panes
  Ctrl+b o                    Cycle through panes
  Ctrl+b z                    Toggle pane zoom (fullscreen)
  Ctrl+b x                    Close current pane
  Ctrl+b { / }                Swap current pane with previous / next
  Ctrl+b q                    Show pane numbers (press number to jump)
  Ctrl+b Space                Cycle pane layout arrangements

Scroll & Copy Mode
  Ctrl+b [                    Enter scroll / copy mode (q to exit)
  Space / Enter               (In copy mode) Start selection / Copy

Help & Commands
  Ctrl+b ?                    Show all tmux keybindings
  Ctrl+b :                    Open tmux command prompt
  Ctrl+b t                    Display digital clock
'@
}
function tobase64 {
    $inputStr = ($input | Out-String)
    if ($inputStr) {
        [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($inputStr))
    }
}
function topb {
    (@($input) -join "`n") | curl.exe -F "file=@-" https://0x0.st
    Write-Host
}
function toqrcode {
    (@($input) -join "`n") | curl.exe "-F-=<-" https://qrenco.de
    Write-Host
}
function transfer {
    $file = $args[0]
    $file_name = if ($file) { Split-Path $file -Leaf } else { 'upload.txt' }

    if ($MyInvocation.ExpectingInput) {
        $tmp = Join-Path ([System.IO.Path]::GetTempPath()) $file_name
        $stream = [System.IO.File]::Create($tmp)
        $writer = New-Object System.IO.StreamWriter($stream, (New-Object System.Text.UTF8Encoding($false)))
        foreach ($line in $input) { $writer.WriteLine($line) }
        $writer.Dispose()
        $stream.Dispose()
        $file = $tmp
    } elseif (-not $file) {
        Write-Error "No arguments specified.`nUsage:`n transfer <file|directory>`n ... | transfer <file_name>"
        return
    } elseif (-not (Test-Path -LiteralPath $file)) {
        Write-Error "${file}: No such file or directory"
        return
    } elseif (Test-Path -LiteralPath $file -PathType Container) {
        $archive = Join-Path ([System.IO.Path]::GetTempPath()) "$file_name.zip"
        Compress-Archive -Path (Join-Path $file '*') -DestinationPath $archive -Force
        $file = $archive
        $file_name = "$file_name.zip"
    }

    curl.exe --progress-bar -F "reqtype=fileupload" -F "time=72h" `
        -F "fileToUpload=@$file;filename=$file_name" `
        "https://litterbox.catbox.moe/resources/internals/api.php"
    Write-Host
}
function tsall {
    ncup
    biome check --write --unsafe .
    depcheck
    ts-unused-exports tsconfig.json
    tsc --noEmit --project .
}
function u {
    Get-ChildItem -Force | Sort-Object LastWriteTime |
        Format-Table Mode, LastWriteTime, Length, Name -AutoSize
}
function updateprofile {
    $bootstrapUrl = "https://raw.githubusercontent.com/chneau/dotfiles/master/bootstrap.ps1"
    Write-Host "Updating PowerShell profile from $bootstrapUrl..." -ForegroundColor Cyan
    Invoke-Expression (Invoke-RestMethod -Uri $bootstrapUrl -Headers @{ 'Cache-Control' = 'no-cache' })
}
function uploadhelp {
    @'
File Upload / Share Commands
============================

Command        Service            Description
-------        -------            -----------
transfer       Catbox/Litterbox   Upload a file, directory (auto-zipped) or piped stdin; 72h expiry
fio            file.io            Upload a file -> single-use download link
fio1           file.io            Upload a file -> single-use link that expires after 1 day
pasteit        paste.rs           Paste a file or piped text -> plain-text share link
tb             termbin.com        Piped text -> plain-text paste link (~1 week retention)
topb           0x0.st             Upload piped stdin (cat file | topb) -> short-link
toqrcode       qrenco.de          Convert piped text into a QR code

Serve / Share (host locally, others download from you):
  servepy         uv run python -m http.server
  webshare        uv run python -m http.server

Usage examples:
  transfer report.pdf
  transfer ./folder            # zips folder and uploads
  cat notes.txt | transfer notes.txt
  fio report.pdf
  pasteit report.md
  cat notes.txt | pasteit
  cat notes.txt | tb
  cat notes.txt | topb
  echo "https://my.link" | toqrcode
'@
}
function wsldocker {
    wsl --user root service docker start
    wsl
}
function ymp3 {
    yt-dlp --restrict-filenames --continue --ignore-errors --download-archive downloaded.txt `
           --no-post-overwrites --no-overwrites --extract-audio --audio-format mp3 `
           --output "%(title)s.%(ext)s" @args
}
# <<< generated aliases <<<
