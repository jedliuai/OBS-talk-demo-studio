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
    public const uint KEYEVENTF_KEYUP = 0x0002;
    public const int WM_NCLBUTTONDOWN = 0x00A1;
    public const int HTCAPTION = 0x0002;

    [DllImport("user32.dll")]
    public static extern bool SetWindowDisplayAffinity(IntPtr hWnd, uint dwAffinity);

    [DllImport("user32.dll")]
    public static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, UIntPtr dwExtraInfo);

    [DllImport("user32.dll")]
    public static extern bool ReleaseCapture();

    [DllImport("user32.dll")]
    public static extern IntPtr SendMessage(IntPtr hWnd, int msg, int wParam, int lParam);

    public static void TapAlt(byte virtualKey)
    {
        keybd_event(0x12, 0, 0, UIntPtr.Zero);
        keybd_event(virtualKey, 0, 0, UIntPtr.Zero);
        keybd_event(virtualKey, 0, KEYEVENTF_KEYUP, UIntPtr.Zero);
        keybd_event(0x12, 0, KEYEVENTF_KEYUP, UIntPtr.Zero);
    }
}
'@

$createdNew = $false
$mutex = [Threading.Mutex]::new($true, 'OBS-Talk-Demo-Studio-Control-Bar', [ref] $createdNew)
if (-not $createdNew) {
    return
}

$form = [Windows.Forms.Form]::new()
$form.Text = 'OBS Talk Demo Studio Control Bar'
$form.FormBorderStyle = [Windows.Forms.FormBorderStyle]::None
$form.StartPosition = [Windows.Forms.FormStartPosition]::Manual
$form.Size = [Drawing.Size]::new(820, 58)
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

function Add-ControlButton {
    param(
        [string] $Text,
        [byte] $VirtualKey,
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
    $button.Add_Click({ [ObsControlBarNative]::TapAlt($VirtualKey) }.GetNewClosure())
    $panel.Controls.Add($button)
    return $button
}

$null = Add-ControlButton -Text '真人  1' -VirtualKey 0x31 -Width 100
$null = Add-ControlButton -Text '录屏 + 人  2' -VirtualKey 0x32 -Width 126
$null = Add-ControlButton -Text '电脑全屏  3' -VirtualKey 0x33 -Width 118
$null = Add-ControlButton -Text '平滑缩放  Z' -VirtualKey 0x5A -Width 120 -Accent '#173765'
$null = Add-ControlButton -Text '跟随切换  X' -VirtualKey 0x58 -Width 120 -Accent '#28346B'
$null = Add-ControlButton -Text '录制  R' -VirtualKey 0x52 -Width 92 -Accent '#5B2445'

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
    $mutex.ReleaseMutex()
    $mutex.Dispose()
}
