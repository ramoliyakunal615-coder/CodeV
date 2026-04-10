Option Explicit

Dim shell, cmd
Set shell = CreateObject("WScript.Shell")

cmd = "powershell -ExecutionPolicy Bypass -File ""D:\WorkSpace\CodeX\CodeV\templates\current\ui_send_codev_command.ps1"" " & _
      "-WindowTitle ""CODE V - ex_all_02_112002"" " & _
      "-SequencePath ""D:\WorkSpace\CodeX\CodeV\templates\current\example_ui_freeze_front5.seq"""

shell.Run cmd, 0, True
