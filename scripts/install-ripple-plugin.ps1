[CmdletBinding()]
param(
    [string] $ObsInstallRoot = ''
)

$ErrorActionPreference = 'Stop'
$releaseUrl = 'https://github.com/jedliuai/OBS-talk-demo-studio/releases/download/v1.5.0/zoominator-ripple-2.0.6-windows-x64.zip'
$expectedSha256 = '808747931964F80A9CEB593C8FE50C40DDC391BCBB0CADBDAC9429328926672E'

if (Get-Process -Name 'obs64' -ErrorAction SilentlyContinue) {
    throw 'OBS 正在运行。请先退出 OBS，再安装插件。'
}

if (-not $ObsInstallRoot) {
    # OBS 安装器会把安装目录写进这个键的默认值；装在非 C 盘时卸载项里常常没有 InstallLocation。
    $obsKey = Get-ItemProperty 'HKLM:\SOFTWARE\OBS Studio' -ErrorAction SilentlyContinue
    if ($obsKey -and $obsKey.'(default)' -and (Test-Path -LiteralPath $obsKey.'(default)')) {
        $ObsInstallRoot = $obsKey.'(default)'.TrimEnd('\')
    }
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

    # 对话框里的新设置项需要同版本的语言文件，否则会显示原始键名。
    $localeSource = Join-Path $extractPath 'data\obs-plugins\zoominator\locale'
    if (Test-Path -LiteralPath $localeSource) {
        $localeDestination = Join-Path $ObsInstallRoot 'data\obs-plugins\zoominator\locale'
        New-Item -ItemType Directory -Force -Path $localeDestination | Out-Null
        Copy-Item -Path (Join-Path $localeSource '*.ini') -Destination $localeDestination -Force
        Write-Host "语言文件已更新：$localeDestination"
    }

    $dllHash = (Get-FileHash -LiteralPath $destination -Algorithm SHA256).Hash
    Write-Host '水波版 Zoominator 安装完成。' -ForegroundColor Green
    Write-Host "插件路径：$destination"
    Write-Host "DLL SHA256：$dllHash"
} finally {
    if (Test-Path -LiteralPath $tempRoot) {
        Remove-Item -LiteralPath $tempRoot -Recurse -Force
    }
}
