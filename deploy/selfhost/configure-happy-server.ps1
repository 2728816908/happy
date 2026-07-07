param(
    [Parameter(Mandatory = $true)]
    [string]$ServerUrl,

    [string]$HappyHomeDir = "$env:USERPROFILE\.happy"
)

$ErrorActionPreference = "Stop"

if (-not ($ServerUrl.StartsWith("http://") -or $ServerUrl.StartsWith("https://"))) {
    throw "ServerUrl must start with http:// or https://"
}

New-Item -ItemType Directory -Force -Path $HappyHomeDir | Out-Null

$settingsPath = Join-Path $HappyHomeDir "settings.json"
$settings = [ordered]@{
    schemaVersion = 2
    onboardingCompleted = $false
    serverUrl = $ServerUrl.TrimEnd("/")
    webappUrl = $ServerUrl.TrimEnd("/")
}

$settings | ConvertTo-Json -Depth 4 | Set-Content -Encoding UTF8 -Path $settingsPath

Write-Host "Happy CLI configured:"
Write-Host "  $settingsPath"
Write-Host "  serverUrl = $($settings.serverUrl)"
Write-Host ""
Write-Host "Next:"
Write-Host "  happy auth login"
Write-Host "  happy daemon start"
Write-Host "  happy codex"
