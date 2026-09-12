# PowerShell Dotfiles Bootstrapper for Windows
# Compatible with Windows PowerShell 5.1 and PowerShell 7+ (pwsh)
# Usage:
#   irm https://raw.githubusercontent.com/chneau/dotfiles/master/bootstrap.ps1 | iex

$ErrorActionPreference = 'Stop'

$baseUrl = "https://raw.githubusercontent.com/chneau/dotfiles/master"
$aliasesFileName = ".aliases.ps1"
$targetLocalAliases = Join-Path $HOME $aliasesFileName
$downloadUrl = "$baseUrl/$aliasesFileName?$([DateTimeOffset]::UtcNow.ToUnixTimeSeconds())"

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  Dotfiles Windows Bootstrapper" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan

# 1. Download .aliases.ps1 to $HOME/.aliases.ps1
Write-Host "Downloading $aliasesFileName to $targetLocalAliases..." -ForegroundColor Yellow
try {
    # Ensure TLS 1.2 is enabled for Windows PowerShell 5.1
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    Invoke-RestMethod -Uri $downloadUrl -OutFile $targetLocalAliases
    Write-Host "Successfully downloaded $aliasesFileName" -ForegroundColor Green
} catch {
    Write-Error "Failed to download $aliasesFileName : $_"
    exit 1
}

# 2. Determine Profile Paths to configure (Both Windows PowerShell 5.1 and PowerShell 7+)
$docsPath = [Environment]::GetFolderPath('MyDocuments')
$profilePaths = @(
    # Currently running shell's profile
    $PROFILE,
    # Windows PowerShell (5.1)
    (Join-Path $docsPath "WindowsPowerShell\Microsoft.PowerShell_profile.ps1"),
    (Join-Path $docsPath "WindowsPowerShell\profile.ps1"),
    # PowerShell 7+ (pwsh)
    (Join-Path $docsPath "PowerShell\Microsoft.PowerShell_profile.ps1"),
    (Join-Path $docsPath "PowerShell\profile.ps1")
) | Select-Object -Unique

# Marker block to include in profile
$markerStart = "# >>> dotfiles aliases >>>"
$markerEnd   = "# <<< dotfiles aliases <<<"
$dotSourceLine = @"
$markerStart
if (Test-Path "`$HOME\$aliasesFileName") {
    . "`$HOME\$aliasesFileName"
}
$markerEnd
"@

# 3. Update Profiles
$timestamp = Get-Date -Format "yyyyMMddHHmmss"

foreach ($p in $profilePaths) {
    if (-not $p) { continue }
    $profileDir = Split-Path -Parent $p

    if (-not (Test-Path $profileDir)) {
        New-Item -ItemType Directory -Force -Path $profileDir | Out-Null
    }

    if (Test-Path $p) {
        $content = Get-Content -Raw -Path $p -ErrorAction SilentlyContinue
        if ($content -and $content.Contains($markerStart)) {
            Write-Host "Updating dotfiles section in $p..." -ForegroundColor Cyan
            # Replace existing block
            $regex = "(?s)" + [regex]::Escape($markerStart) + ".*?" + [regex]::Escape($markerEnd)
            $newContent = [regex]::Replace($content, $regex, $dotSourceLine)
            Set-Content -Path $p -Value $newContent -Encoding UTF8
        } else {
            Write-Host "Backing up existing profile: $p -> $p.bak.$timestamp" -ForegroundColor DarkGray
            Copy-Item -Path $p -Destination "$p.bak.$timestamp" -Force
            Write-Host "Appending dotfiles loader to $p..." -ForegroundColor Green
            Add-Content -Path $p -Value "`n$dotSourceLine`n" -Encoding UTF8
        }
    } else {
        Write-Host "Creating new profile with dotfiles loader: $p" -ForegroundColor Green
        Set-Content -Path $p -Value $dotSourceLine -Encoding UTF8
    }
}

# 4. Dot-source in current session
if (Test-Path $targetLocalAliases) {
    Write-Host "Loading aliases into current session..." -ForegroundColor Green
    . $targetLocalAliases
}

Write-Host "`nAll set! Dotfiles and aliases are loaded and will run automatically on every PowerShell launch." -ForegroundColor Green
