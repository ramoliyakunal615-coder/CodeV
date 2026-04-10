Option Explicit

Dim shell, args, seqPath, cmd
Set shell = CreateObject("WScript.Shell")
Set args = WScript.Arguments

If args.Count < 1 Then
    WScript.Echo "Usage: ui_run_current_seq.vbs <sequence-path>"
    WScript.Quit 1
End If

seqPath = args.Item(0)

On Error Resume Next
shell.AppActivate "CODE V"
WScript.Sleep 300
On Error GoTo 0

cmd = "powershell -ExecutionPolicy Bypass -File ""D:\WorkSpace\CodeX\CodeV\templates\current\ui_send_codev_command.ps1"" " & _
      "-SequencePath """ & seqPath & """"

shell.Run cmd, 0, True
