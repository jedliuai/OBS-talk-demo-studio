[CmdletBinding()]
param(
    [string] $RecordPath = (Join-Path $env:USERPROFILE 'Videos\OBS-talk-demo-studio')
)

$ErrorActionPreference = 'Stop'

if (Get-Process -Name 'obs64' -ErrorAction SilentlyContinue) {
    throw 'OBS 正在运行。请先退出 OBS，再重新运行安装脚本。'
}

$repoRoot = Split-Path -Parent $PSScriptRoot
$obsRoot = Join-Path $env:APPDATA 'obs-studio'
$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$backupRoot = Join-Path $obsRoot "OBS-talk-demo-studio-backups\$timestamp"

$sceneSource = Join-Path $repoRoot 'obs\scene-collection\个人IP录制工作台.template.json'
$profileSource = Join-Path $repoRoot 'obs\profile\basic.ini'
$pluginSource = Join-Path $repoRoot 'obs\plugin-config\zoominator.json'
$imageSource = Join-Path $repoRoot 'assets\jed-midnight-studio-clean.png'
$videoSource = Join-Path $repoRoot 'assets\jed-midnight-studio-loop-v2.mp4'
$maskSource = Join-Path $repoRoot 'assets\camera-circle-mask.png'
$frameSource = Join-Path $repoRoot 'assets\camera-circle-frame-midnight.png'

$sceneTarget = Join-Path $obsRoot 'basic\scenes\个人IP录制工作台.json'
$profileTarget = Join-Path $obsRoot 'basic\profiles\个人IP录制_1440p30\basic.ini'
$pluginTarget = Join-Path $obsRoot 'plugin_config\zoominator\zoominator.json'
$assetTargetRoot = Join-Path $obsRoot 'basic\assets\OBS-talk-demo-studio'
$imageTarget = Join-Path $assetTargetRoot 'jed-midnight-studio-clean.png'
$videoTarget = Join-Path $assetTargetRoot 'jed-midnight-studio-loop-v2.mp4'
$maskTarget = Join-Path $assetTargetRoot 'camera-circle-mask.png'
$frameTarget = Join-Path $assetTargetRoot 'camera-circle-frame-midnight.png'

foreach ($target in @($sceneTarget, $profileTarget, $pluginTarget)) {
    if (Test-Path -LiteralPath $target) {
        $relative = [IO.Path]::GetRelativePath($obsRoot, $target)
        $backup = Join-Path $backupRoot $relative
        New-Item -ItemType Directory -Force -Path (Split-Path -Parent $backup) | Out-Null
        Copy-Item -LiteralPath $target -Destination $backup -Force
    }
}

New-Item -ItemType Directory -Force -Path `
    (Split-Path -Parent $sceneTarget), `
    (Split-Path -Parent $profileTarget), `
    (Split-Path -Parent $pluginTarget), `
    $assetTargetRoot, `
    $RecordPath | Out-Null

Copy-Item -LiteralPath $imageSource -Destination $imageTarget -Force
Copy-Item -LiteralPath $videoSource -Destination $videoTarget -Force
Copy-Item -LiteralPath $maskSource -Destination $maskTarget -Force
Copy-Item -LiteralPath $frameSource -Destination $frameTarget -Force

$videoJsonPath = $videoTarget.Replace('\', '\\')
$maskJsonPath = $maskTarget.Replace('\', '\\')
$frameJsonPath = $frameTarget.Replace('\', '\\')
$sceneText = [IO.File]::ReadAllText($sceneSource)
$sceneText = $sceneText.Replace('{{VIDEO_ASSET_PATH}}', $videoJsonPath)
$sceneText = $sceneText.Replace('{{MASK_ASSET_PATH}}', $maskJsonPath)
$sceneText = $sceneText.Replace('{{FRAME_ASSET_PATH}}', $frameJsonPath)
[IO.File]::WriteAllText($sceneTarget, $sceneText, [Text.UTF8Encoding]::new($false))

$recordIniPath = $RecordPath.Replace('\', '\\')
$profileText = [IO.File]::ReadAllText($profileSource).Replace('{{RECORD_PATH}}', $recordIniPath)
[IO.File]::WriteAllText($profileTarget, $profileText, [Text.UTF8Encoding]::new($false))

Copy-Item -LiteralPath $pluginSource -Destination $pluginTarget -Force

Write-Host '安装完成。' -ForegroundColor Green
Write-Host "场景集合：$sceneTarget"
Write-Host "配置文件：$profileTarget"
Write-Host "录制目录：$RecordPath"
if (Test-Path -LiteralPath $backupRoot) {
    Write-Host "原配置备份：$backupRoot"
}
Write-Host '重新打开 OBS 后，请选择自己的窗口、摄像头和麦克风。'
