<#
.SYNOPSIS
    Bootstrap script for Windows (Scoop + Chezmoi)
.DESCRIPTION
    1. Installs Scoop, Git, Chezmoi (User Scope)
    2. Provisions Age key
    3. Runs chezmoi init --apply
    
    NOTE: This script should be run as a Standard User, NOT Administrator.
    Scoop does not support running as Administrator.
    Sub-scripts managed by Chezmoi will request Admin privileges (UAC) if needed.
#>

$ScriptPath = $MyInvocation.MyCommand.Path
$ScriptDir = Split-Path $ScriptPath

Write-Host "==> Bootstrapping Dotfiles for Windows <==" -ForegroundColor Green

# 1. Execution Policy (Scope: Process)
Write-Host "[*] Setting Execution Policy to Bypass (Process scope)..." -ForegroundColor Yellow
Set-ExecutionPolicy Bypass -Scope Process -Force

# 2. Install Scoop (if missing)
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "[*] Installing Scoop..." -ForegroundColor Yellow
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
} else {
    Write-Host "[✓] Scoop is already installed." -ForegroundColor Green
}

# 3. Install Dependencies (Git, Chezmoi)
$Dependencies = @("git", "chezmoi")
foreach ($dep in $Dependencies) {
    if (-not (Get-Command $dep -ErrorAction SilentlyContinue)) {
        Write-Host "[*] Installing $dep..." -ForegroundColor Yellow
        scoop install $dep
    } else {
        Write-Host "[✓] $dep is already installed." -ForegroundColor Green
    }
}

# 4. Provision Age Key
$KeyPath = "$HOME\.age-key.txt"
if (-not (Test-Path $KeyPath)) {
    Write-Host "[!] Age key not found at $KeyPath" -ForegroundColor Red
    $AgeKey = Read-Host "Paste your Age secret key (starts with AGE-SECRET-KEY-)"
    
    if ($AgeKey -notmatch "^AGE-SECRET-KEY-") {
        Write-Error "Invalid key format. Must start with AGE-SECRET-KEY-"
        exit 1
    }
    
    Set-Content -Path $KeyPath -Value $AgeKey -Encoding ascii
    Write-Host "[✓] Key saved." -ForegroundColor Green
} else {
    Write-Host "[✓] Age key present." -ForegroundColor Green
}

# 5. Handover to Chezmoi
Write-Host "==> Handing over to Chezmoi..." -ForegroundColor Green
Write-Host "NOTE: You may receive UAC prompts for system configuration." -ForegroundColor Yellow

# Ensure we are in the repo root
Set-Location $ScriptDir
chezmoi init --apply --source .
