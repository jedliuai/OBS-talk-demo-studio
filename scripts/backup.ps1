[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$obsRoot = Join-Path $env:APPDATA 'obs-studio'
$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$target = Join-Path $repoRoot "local-backups\$timestamp"

$items = @(
    'basic\scenes\个人IP录制工作台.json',
    'basic\profiles\个人IP录制_1440p30\basic.ini',
    'plugin_config\zoominator\zoominator.json'
)

foreach ($relative in $items) {
    $source = Join-Path $obsRoot $relative
    if (Test-Path -LiteralPath $source) {
        $destination = Join-Path $target $relative
        New-Item -ItemType Directory -Force -Path (Split-Path -Parent $destination) | Out-Null
        Copy-Item -LiteralPath $source -Destination $destination -Force
    }
}

Write-Host "本机配置已备份到：$target" -ForegroundColor Green
