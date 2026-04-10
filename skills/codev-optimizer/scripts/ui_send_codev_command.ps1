param(
    [string]$WindowTitle,

    [string]$Command,

    [string]$SequencePath,

    [string]$LogPath = "D:\WorkSpace\CodeX\CodeV\templates\current\ui_send_codev_command.log"
)

$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName UIAutomationClient
Add-Type -AssemblyName UIAutomationTypes

Add-Type @"
using System;
using System.Text;
using System.Runtime.InteropServices;
public class UiSend {
  [DllImport("user32.dll")] public static extern bool EnumWindows(EnumWindowsProc lpEnumFunc, IntPtr lParam);
  public delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr hWnd);
  [DllImport("user32.dll")] public static extern int GetWindowTextLength(IntPtr hWnd);
  [DllImport("user32.dll")] public static extern int GetWindowText(IntPtr hWnd, StringBuilder text, int count);
  [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr hWnd, out RECT rect);
  [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr hWnd);
  [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
  [DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();
  [DllImport("user32.dll")] public static extern bool SetCursorPos(int X, int Y);
  [DllImport("user32.dll")] public static extern bool GetCursorPos(out POINT point);
  [DllImport("user32.dll")] public static extern void mouse_event(uint dwFlags, uint dx, uint dy, uint dwData, UIntPtr dwExtraInfo);
  public struct RECT { public int Left; public int Top; public int Right; public int Bottom; }
  public struct POINT { public int X; public int Y; }
  public const int SW_RESTORE = 9;
  public const uint MOUSEEVENTF_LEFTDOWN = 0x0002;
  public const uint MOUSEEVENTF_LEFTUP = 0x0004;
}
"@

if ([string]::IsNullOrWhiteSpace($Command) -and [string]::IsNullOrWhiteSpace($SequencePath)) {
    throw "Either -Command or -SequencePath is required."
}

if (-not [string]::IsNullOrWhiteSpace($SequencePath)) {
    $Command = 'IN "{0}"' -f $SequencePath
}

function Get-WindowText([IntPtr]$hWnd) {
    $len = [UiSend]::GetWindowTextLength($hWnd)
    if ($len -le 0) { return "" }
    $sb = New-Object System.Text.StringBuilder ($len + 1)
    [void][UiSend]::GetWindowText($hWnd, $sb, $sb.Capacity)
    $sb.ToString()
}

function Get-CodeVWindowElement([string]$titlePrefix) {
    if ([string]::IsNullOrWhiteSpace($titlePrefix)) {
        return $null
    }
    $root = [System.Windows.Automation.AutomationElement]::RootElement
    $children = $root.FindAll(
        [System.Windows.Automation.TreeScope]::Children,
        [System.Windows.Automation.Condition]::TrueCondition
    )
    for ($i = 0; $i -lt $children.Count; $i++) {
        $item = $children.Item($i)
        if ($item.Current.Name -like ($titlePrefix + '*')) {
            return $item
        }
    }
    return $null
}

function Get-CodeVForegroundWindowElement {
    $foreground = [UiSend]::GetForegroundWindow()
    if ($foreground -eq [IntPtr]::Zero) { return $null }
    $title = Get-WindowText $foreground
    if ([string]::IsNullOrWhiteSpace($title) -or ($title -notlike 'CODE V*')) {
        return $null
    }

    $root = [System.Windows.Automation.AutomationElement]::RootElement
    $children = $root.FindAll(
        [System.Windows.Automation.TreeScope]::Children,
        [System.Windows.Automation.Condition]::TrueCondition
    )
    for ($i = 0; $i -lt $children.Count; $i++) {
        $item = $children.Item($i)
        if ($item.Current.NativeWindowHandle -eq $foreground.ToInt32()) {
            return $item
        }
    }
    return $null
}

function Find-CommandEdit([System.Windows.Automation.AutomationElement]$windowElement) {
    $nameCond = New-Object System.Windows.Automation.PropertyCondition(
        [System.Windows.Automation.AutomationElement]::NameProperty,
        "Command Window"
    )
    $commandWindow = $windowElement.FindFirst([System.Windows.Automation.TreeScope]::Descendants, $nameCond)
    if ($null -eq $commandWindow) { return $null }

    $aidCond = New-Object System.Windows.Automation.PropertyCondition(
        [System.Windows.Automation.AutomationElement]::AutomationIdProperty,
        "1001"
    )
    $typeCond = New-Object System.Windows.Automation.PropertyCondition(
        [System.Windows.Automation.AutomationElement]::ControlTypeProperty,
        [System.Windows.Automation.ControlType]::Edit
    )
    $andCond = New-Object System.Windows.Automation.AndCondition($aidCond, $typeCond)
    $edit = $commandWindow.FindFirst([System.Windows.Automation.TreeScope]::Descendants, $andCond)
    if ($null -ne $edit) { return $edit }

    return $commandWindow.FindFirst([System.Windows.Automation.TreeScope]::Descendants, $typeCond)
}

function Wait-CommandEditEnabled([System.Windows.Automation.AutomationElement]$windowElement, [int]$timeoutMs = 12000) {
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    while ($sw.ElapsedMilliseconds -lt $timeoutMs) {
        $candidate = Find-CommandEdit $windowElement
        if ($null -ne $candidate) {
            try {
                if ($candidate.Current.IsEnabled) {
                    return $candidate
                }
            } catch {}
        }
        Start-Sleep -Milliseconds 250
    }
    return $null
}

$windowElement = Get-CodeVWindowElement $WindowTitle
if ($null -eq $windowElement) {
    $windowElement = Get-CodeVForegroundWindowElement
}
if ($null -eq $windowElement) {
    "UIA_WINDOW_NOT_FOUND: $WindowTitle" | Set-Content -LiteralPath $LogPath -Encoding UTF8
    exit 1
}

$target = [IntPtr]$windowElement.Current.NativeWindowHandle
if ($target -eq [IntPtr]::Zero) {
    "NATIVE_HANDLE_NOT_FOUND: $WindowTitle" | Set-Content -LiteralPath $LogPath -Encoding UTF8
    exit 1
}

$commandEdit = Wait-CommandEditEnabled $windowElement
if ($null -eq $commandEdit) {
    "COMMAND_EDIT_NOT_READY: $WindowTitle" | Set-Content -LiteralPath $LogPath -Encoding UTF8
    exit 1
}

$rect = New-Object UiSend+RECT
[void][UiSend]::GetWindowRect($target, [ref]$rect)
[UiSend]::ShowWindow($target, [UiSend]::SW_RESTORE) | Out-Null
[UiSend]::SetForegroundWindow($target) | Out-Null
Start-Sleep -Milliseconds 300

$editRect = $commandEdit.Current.BoundingRectangle
$x = [int]($editRect.Left + 20)
$y = [int]($editRect.Top + ($editRect.Height / 2))

[UiSend]::SetCursorPos($x, $y) | Out-Null
Start-Sleep -Milliseconds 100
[UiSend]::mouse_event([UiSend]::MOUSEEVENTF_LEFTDOWN, 0, 0, 0, [UIntPtr]::Zero)
[UiSend]::mouse_event([UiSend]::MOUSEEVENTF_LEFTUP, 0, 0, 0, [UIntPtr]::Zero)
Start-Sleep -Milliseconds 150

try {
    $commandEdit.SetFocus()
} catch {}
Start-Sleep -Milliseconds 100

$inputMethod = "ValuePattern"
$inputError = ""
try {
    $valuePattern = $commandEdit.GetCurrentPattern([System.Windows.Automation.ValuePattern]::Pattern)
    $valuePattern.SetValue($Command)
} catch {
    $inputMethod = "SendKeysFallback"
    $inputError = $_.Exception.Message
    [System.Windows.Forms.Clipboard]::SetText($Command)
    Start-Sleep -Milliseconds 100

    $ws = New-Object -ComObject WScript.Shell
    $ws.SendKeys('^a')
    Start-Sleep -Milliseconds 100
    $ws.SendKeys('{BACKSPACE}')
    Start-Sleep -Milliseconds 100
    $ws.SendKeys('^v')
}
Start-Sleep -Milliseconds 150

$ws = New-Object -ComObject WScript.Shell
$ws.SendKeys('~')

@(
    "WINDOW=$WindowTitle"
    "RECT=$($rect.Left),$($rect.Top),$($rect.Right),$($rect.Bottom)"
    "EDIT_RECT=$($editRect.Left),$($editRect.Top),$($editRect.Width),$($editRect.Height)"
    "CLICK=$x,$y"
    "COMMAND=$Command"
    "INPUT_METHOD=$inputMethod"
    "INPUT_ERROR=$inputError"
    "STATUS=OK"
) | Set-Content -LiteralPath $LogPath -Encoding UTF8
