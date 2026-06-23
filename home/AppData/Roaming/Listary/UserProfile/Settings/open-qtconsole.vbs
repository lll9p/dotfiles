Set shell = CreateObject("WScript.Shell")

localAppData = shell.ExpandEnvironmentStrings("%LOCALAPPDATA%")
pythonExe = localAppData & "\Programs\virtualenvs\work\Scripts\python.exe"

shell.Run Quote(pythonExe) & " -m qtconsole", 0, False

Function Quote(value)
  Quote = Chr(34) & value & Chr(34)
End Function
