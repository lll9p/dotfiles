Set shell = CreateObject("WScript.Shell")

localAppData = shell.ExpandEnvironmentStrings("%LOCALAPPDATA%")
systemRoot = shell.ExpandEnvironmentStrings("%SystemRoot%")
userProfile = shell.ExpandEnvironmentStrings("%USERPROFILE%")
pythonExe = localAppData & "\Programs\virtualenvs\work\Scripts\python.exe"
powershellExe = systemRoot & "\System32\WindowsPowerShell\v1.0\powershell.exe"

command = "$psi = New-Object System.Diagnostics.ProcessStartInfo; " & _
  "$psi.FileName = '" & EscapePowerShellSingleQuoted(pythonExe) & "'; " & _
  "$psi.Arguments = '-m qtconsole'; " & _
  "$psi.WorkingDirectory = '" & EscapePowerShellSingleQuoted(userProfile) & "'; " & _
  "$psi.UseShellExecute = $false; " & _
  "$psi.CreateNoWindow = $true; " & _
  "[System.Diagnostics.Process]::Start($psi) | Out-Null"

shell.Run Quote(powershellExe) & " -NoProfile -NonInteractive -ExecutionPolicy Bypass -WindowStyle Hidden -Command " & Quote(command), 0, False

Function Quote(value)
  Quote = Chr(34) & value & Chr(34)
End Function

Function EscapePowerShellSingleQuoted(value)
  EscapePowerShellSingleQuoted = Replace(value, "'", "''")
End Function
