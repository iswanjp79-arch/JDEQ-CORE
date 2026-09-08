Set shell = CreateObject("WScript.Shell")
shell.Run "powershell.exe -NoProfile -ExecutionPolicy Bypass -File ""D:\MICO_SSOT\TREE_L\05_PIPELINE\orchestrator.ps1"" -Mode loop", 0, False
