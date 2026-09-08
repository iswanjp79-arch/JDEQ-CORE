Set shell = CreateObject("WScript.Shell")
shell.Run "powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File ""D:\MICO_SSOT\TREE_L\10_SECURITY\heartbeat_silent.ps1""", 0, False
