[CmdletBinding()]
param(
    [string] $ObsInstallRoot = ''
)

$ErrorActionPreference = 'Stop'
$releaseUrl = 'https://github.com/jedliuai/OBS-talk-demo-studio/releases/download/v1.4.1/zoominator-ripple-2.0.6-windows-x64.zip'
$expectedSha256 = '95A8DCB5F4F87C1ADA623517CC99B66FA01A627A6D512D44D669DFA9D73B6D2B'

if (Get-Process -Name 'obs64' -ErrorAction SilentlyContinue) {
    throw 'OBS 正在运行。请先退出 OBS，再安装插件。'
}

if (-not $ObsInstallRoot) {
    $uninstallRoots = @(
        'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*',
        'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
    )
    $installed = Get-ItemProperty $uninstallRoots -ErrorAction SilentlyContinue |
        Where-Object { $_.DisplayName -like 'OBS Studio*' -and $_.InstallLocation } |
        Select-Object -First 1
    if ($installed) {
        $ObsInstallRoot = $installed.InstallLocation.TrimEnd('\')
    } else {
        $ObsInstallRoot = Join-Path $env:ProgramFiles 'obs-studio'
    }
}

$destination = Join-Path $ObsInstallRoot 'obs-plugins\64bit\zoominator.dll'
if (-not (Test-Path -LiteralPath (Split-Path -Parent $destination))) {
    throw "没有找到 OBS 插件目录：$(Split-Path -Parent $destination)。请用 -ObsInstallRoot 指定 OBS 安装目录。"
}

$tempRoot = Join-Path ([IO.Path]::GetTempPath()) "obs-talk-demo-studio-$([guid]::NewGuid().ToString('N'))"
$zipPath = Join-Path $tempRoot 'zoominator-ripple.zip'
$extractPath = Join-Path $tempRoot 'extracted'
New-Item -ItemType Directory -Force -Path $tempRoot | Out-Null

try {
    Invoke-WebRequest -Uri $releaseUrl -OutFile $zipPath
    $actualHash = (Get-FileHash -LiteralPath $zipPath -Algorithm SHA256).Hash
    if ($actualHash -ne $expectedSha256) {
        throw "下载文件校验失败。期望 $expectedSha256，实际 $actualHash。"
    }

    Expand-Archive -LiteralPath $zipPath -DestinationPath $extractPath -Force
    $source = Join-Path $extractPath 'obs-plugins\64bit\zoominator.dll'
    if (-not (Test-Path -LiteralPath $source)) {
        throw '构建产物中没有找到 zoominator.dll。'
    }

    if (Test-Path -LiteralPath $destination) {
        $backup = "$destination.before-ripple-$(Get-Date -Format 'yyyyMMdd-HHmmss').bak"
        Copy-Item -LiteralPath $destination -Destination $backup -Force
        Write-Host "原插件已备份：$backup"
    }

    Copy-Item -LiteralPath $source -Destination $destination -Force
    $dllHash = (Get-FileHash -LiteralPath $destination -Algorithm SHA256).Hash
    Write-Host '水波版 Zoominator 安装完成。' -ForegroundColor Green
    Write-Host "插件路径：$destination"
    Write-Host "DLL SHA256：$dllHash"
} finally {
    if (Test-Path -LiteralPath $tempRoot) {
        Remove-Item -LiteralPath $tempRoot -Recurse -Force
    }
}
