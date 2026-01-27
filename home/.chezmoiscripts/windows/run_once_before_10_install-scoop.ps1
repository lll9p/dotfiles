$ErrorActionPreference = 'Stop'

if (Get-Command 'scoop' -ErrorAction SilentlyContinue) {
    Write-Host 'Scoop already installed, skipping.' -ForegroundColor Green
    exit 0
}

Write-Host 'INSTALLING SCOOP...' -ForegroundColor Cyan

try {
    $installScript = Invoke-RestMethod -Uri 'https://get.scoop.sh'
    Invoke-Expression $installScript
    Write-Host 'Scoop installed successfully.' -ForegroundColor Green
}
catch {
    Write-Error "Failed to install Scoop: $($_.Exception.Message)"
    exit 1
}
