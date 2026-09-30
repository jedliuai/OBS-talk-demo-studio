[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;

public static class ObsControlBarNative
{
    public const uint WDA_EXCLUDEFROMCAPTURE = 0x00000011;
    public const int WM_NCLBUTTONDOWN = 0x00A1;
    public const int HTCAPTION = 0x0002;

    [DllImport("user32.dll")]
    public static extern bool SetWindowDisplayAffinity(IntPtr hWnd, uint dwAffinity);

    [DllImport("user32.dll")]
    public static extern bool ReleaseCapture();

    [DllImport("user32.dll")]
    public static extern IntPtr SendMessage(IntPtr hWnd, int msg, int wParam, int lParam);

}
'@

function Receive-ObsMessage {
    param([Net.WebSockets.ClientWebSocket] $Socket)

    $buffer = [byte[]]::new(8192)
    $stream = [IO.MemoryStream]::new()
    try {
        do {
            $segment = [ArraySegment[byte]]::new($buffer)
            $result = $Socket.ReceiveAsync(
                $segment,
                [Threading.CancellationToken]::None
            ).GetAwaiter().GetResult()

            if ($result.MessageType -eq [Net.WebSockets.WebSocketMessageType]::Close) {
                throw 'OBS WebSocket 已断开'
            }

            $stream.Write($buffer, 0, $result.Count)
        } while (-not $result.EndOfMessage)

        return [Text.Encoding]::UTF8.GetString($stream.ToArray()) | ConvertFrom-Json
    }
    finally {
        $stream.Dispose()
    }
}

function Send-ObsMessage {
    param(
        [Net.WebSockets.ClientWebSocket] $Socket,
        [hashtable] $Message
    )

    $json = $Message | ConvertTo-Json -Depth 10 -Compress
    $bytes = [Text.Encoding]::UTF8.GetBytes($json)
    $segment = [ArraySegment[byte]]::new($bytes)
    $Socket.SendAsync(
        $segment,
        [Net.WebSockets.WebSocketMessageType]::Text,
        $true,
        [Threading.CancellationToken]::None
    ).GetAwaiter().GetResult()
}

function Connect-ObsWebSocket {
    if ($script:ObsSocket -and $script:ObsSocket.State -eq [Net.WebSockets.WebSocketState]::Open) {
        return
    }

    if ($script:ObsSocket) {
        $script:ObsSocket.Dispose()
    }

    $configPath = Join-Path $env:APPDATA 'obs-studio\plugin_config\obs-websocket\config.json'
    if (-not (Test-Path -LiteralPath $configPath)) {
        throw '未找到 OBS WebSocket 配置，请先启动 OBS'
    }

    $config = Get-Content -LiteralPath $configPath -Raw | ConvertFrom-Json
    if (-not $config.server_enabled) {
        throw 'OBS WebSocket 服务未启用'
    }

    $script:ObsSocket = [Net.WebSockets.ClientWebSocket]::new()
    $script:ObsSocket.Options.KeepAliveInterval = [TimeSpan]::FromSeconds(20)
    $uri = [Uri]::new("ws://127.0.0.1:$($config.server_port)")
    $script:ObsSocket.ConnectAsync(
        $uri,
        [Threading.CancellationToken]::None
    ).GetAwaiter().GetResult()

    $hello = Receive-ObsMessage -Socket $script:ObsSocket
    if ($hello.op -ne 0) {
        throw 'OBS WebSocket 握手失败'
    }

    $identifyData = @{ rpcVersion = 1 }
    if ($hello.d.authentication) {
        $utf8 = [Text.Encoding]::UTF8
        $sha = [Security.Cryptography.SHA256]::Create()
        try {
            $secretInput = "$($config.server_password)$($hello.d.authentication.salt)"
            $secret = [Convert]::ToBase64String($sha.ComputeHash($utf8.GetBytes($secretInput)))
            $authInput = "$secret$($hello.d.authentication.challenge)"
            $identifyData.authentication = [Convert]::ToBase64String(
                $sha.ComputeHash($utf8.GetBytes($authInput))
            )
        }
        finally {
            $sha.Dispose()
        }
    }

    Send-ObsMessage -Socket $script:ObsSocket -Message @{ op = 1; d = $identifyData }
    $identified = Receive-ObsMessage -Socket $script:ObsSocket
    if ($identified.op -ne 2) {
        throw 'OBS WebSocket 身份验证失败'
    }
}

function Invoke-ObsRequest {
    param(
        [string] $RequestType,
        [hashtable] $RequestData = @{}
    )

    Connect-ObsWebSocket
    $requestId = [Guid]::NewGuid().ToString('N')
    Send-ObsMessage -Socket $script:ObsSocket -Message @{
        op = 6
        d = @{
            requestType = $RequestType
            requestId = $requestId
            requestData = $RequestData
        }
    }

    do {
        $response = Receive-ObsMessage -Socket $script:ObsSocket
    } while ($response.op -ne 7 -or $response.d.requestId -ne $requestId)

    if (-not $response.d.requestStatus.result) {
        throw "OBS 操作失败：$($response.d.requestStatus.comment)"
    }
}

$createdNew = $false
$mutex = [Threading.Mutex]::new($true, 'OBS-Talk-Demo-Studio-Control-Bar', [ref] $createdNew)
if (-not $createdNew) {
    return
}

$form = [Windows.Forms.Form]::new()
$form.Text = 'OBS Talk Demo Studio Control Bar'
$form.FormBorderStyle = [Windows.Forms.FormBorderStyle]::None
$form.StartPosition = [Windows.Forms.FormStartPosition]::Manual
$form.Size = [Drawing.Size]::new(940, 58)
$form.BackColor = [Drawing.ColorTranslator]::FromHtml('#071124')
$form.TopMost = $true
$form.ShowInTaskbar = $false
$form.Opacity = 0.97
$form.AutoScaleMode = [Windows.Forms.AutoScaleMode]::Dpi

$workArea = [Windows.Forms.Screen]::PrimaryScreen.WorkingArea
$form.Location = [Drawing.Point]::new(
    [Math]::Max($workArea.Left, $workArea.Left + [int](($workArea.Width - $form.Width) / 2)),
    $workArea.Top + 12
)

$panel = [Windows.Forms.FlowLayoutPanel]::new()
$panel.Dock = [Windows.Forms.DockStyle]::Fill
$panel.Padding = [Windows.Forms.Padding]::new(10, 9, 8, 7)
$panel.WrapContents = $false
$panel.BackColor = $form.BackColor
$form.Controls.Add($panel)

$drag = {
    [ObsControlBarNative]::ReleaseCapture() | Out-Null
    [ObsControlBarNative]::SendMessage($form.Handle, [ObsControlBarNative]::WM_NCLBUTTONDOWN, [ObsControlBarNative]::HTCAPTION, 0) | Out-Null
}
$panel.Add_MouseDown($drag)

$status = [Windows.Forms.Label]::new()
$status.Text = 'OBS 待命'
$status.Size = [Drawing.Size]::new(104, 38)
$status.Margin = [Windows.Forms.Padding]::new(7, 0, 0, 0)
$status.TextAlign = [Drawing.ContentAlignment]::MiddleCenter
$status.ForeColor = [Drawing.ColorTranslator]::FromHtml('#91A6C9')
$status.Font = [Drawing.Font]::new('Microsoft YaHei UI', 8, [Drawing.FontStyle]::Regular)

$buttonClick = {
    param($sender, $eventArgs)

    $sender.Enabled = $false
    $status.Text = '执行中…'
    $status.ForeColor = [Drawing.ColorTranslator]::FromHtml('#91A6C9')
    [Windows.Forms.Application]::DoEvents()

    try {
        switch ($sender.Tag.Kind) {
            'Scene' {
                Invoke-ObsRequest -RequestType 'SetCurrentProgramScene' -RequestData @{
                    sceneName = $sender.Tag.Value
                }
            }
            'Hotkey' {
                Invoke-ObsRequest -RequestType 'TriggerHotkeyByName' -RequestData @{
                    hotkeyName = $sender.Tag.Value
                }
            }
            'Record' {
                Invoke-ObsRequest -RequestType 'ToggleRecord'
            }
        }

        $status.Text = '已执行'
        $status.ForeColor = [Drawing.ColorTranslator]::FromHtml('#73D6C9')
    }
    catch {
        if ($script:ObsSocket) {
            $script:ObsSocket.Dispose()
            $script:ObsSocket = $null
        }
        $status.Text = '连接失败'
        $status.ForeColor = [Drawing.ColorTranslator]::FromHtml('#FF8AAE')
        [Windows.Forms.MessageBox]::Show(
            $_.Exception.Message,
            'OBS 控制条',
            [Windows.Forms.MessageBoxButtons]::OK,
            [Windows.Forms.MessageBoxIcon]::Warning
        ) | Out-Null
    }
    finally {
        $sender.Enabled = $true
    }
}

function Add-ControlButton {
    param(
        [string] $Text,
        [ValidateSet('Scene', 'Hotkey', 'Record')]
        [string] $Kind,
        [string] $Value = '',
        [int] $Width = 118,
        [string] $Accent = '#172B50'
    )

    $button = [Windows.Forms.Button]::new()
    $button.Text = $Text
    $button.Size = [Drawing.Size]::new($Width, 38)
    $button.Margin = [Windows.Forms.Padding]::new(3, 0, 3, 0)
    $button.FlatStyle = [Windows.Forms.FlatStyle]::Flat
    $button.FlatAppearance.BorderSize = 1
    $button.FlatAppearance.BorderColor = [Drawing.ColorTranslator]::FromHtml('#456FAE')
    $button.BackColor = [Drawing.ColorTranslator]::FromHtml($Accent)
    $button.ForeColor = [Drawing.ColorTranslator]::FromHtml('#EAF2FF')
    $button.Font = [Drawing.Font]::new('Microsoft YaHei UI', 9, [Drawing.FontStyle]::Regular)
    $button.Cursor = [Windows.Forms.Cursors]::Hand
    $button.Tag = [pscustomobject]@{ Kind = $Kind; Value = $Value }
    $button.Add_Click($buttonClick)
    $panel.Controls.Add($button)
    return $button
}

$null = Add-ControlButton -Text '真人  1' -Kind Scene -Value '01 真人全屏' -Width 100
$null = Add-ControlButton -Text '录屏 + 人  2' -Kind Scene -Value '02 电脑录屏 + 真人小窗' -Width 126
$null = Add-ControlButton -Text '电脑全屏  3' -Kind Scene -Value '03 电脑录屏全屏' -Width 118
$null = Add-ControlButton -Text '平滑缩放  Z' -Kind Hotkey -Value 'zoominator.toggle_zoom' -Width 120 -Accent '#173765'
$null = Add-ControlButton -Text '跟随切换  X' -Kind Hotkey -Value 'zoominator.toggle_follow' -Width 120 -Accent '#28346B'
$null = Add-ControlButton -Text '录制  R' -Kind Record -Width 92 -Accent '#5B2445'

$close = [Windows.Forms.Button]::new()
$close.Text = '×'
$close.Size = [Drawing.Size]::new(38, 38)
$close.Margin = [Windows.Forms.Padding]::new(5, 0, 0, 0)
$close.FlatStyle = [Windows.Forms.FlatStyle]::Flat
$close.FlatAppearance.BorderSize = 0
$close.BackColor = $form.BackColor
$close.ForeColor = [Drawing.ColorTranslator]::FromHtml('#91A6C9')
$close.Font = [Drawing.Font]::new('Segoe UI', 13, [Drawing.FontStyle]::Regular)
$close.Cursor = [Windows.Forms.Cursors]::Hand
$close.Add_Click({ $form.Close() })
$panel.Controls.Add($close)
$panel.Controls.Add($status)

$form.Add_Shown({
    # Windows 10 2004+ hides this window from Windows Graphics Capture and display capture.
    [ObsControlBarNative]::SetWindowDisplayAffinity(
        $form.Handle,
        [ObsControlBarNative]::WDA_EXCLUDEFROMCAPTURE
    ) | Out-Null
    $form.Activate()
})

$form.Add_MouseDown($drag)

try {
    [Windows.Forms.Application]::Run($form)
}
finally {
    if ($script:ObsSocket) {
        $script:ObsSocket.Dispose()
    }
    $mutex.ReleaseMutex()
    $mutex.Dispose()
}
