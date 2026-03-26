@echo off
net session >nul 2>&1
if %errorLevel% neq 0 (echo [!] Run as Admin & pause & exit)

set "fakeID=SystemUpdate.{21EC2020-3AEA-1069-A2DD-08002B30309D}"
set "target=C:\ProgramData\%fakeID%"

echo [+] Killing Goose Processes...
taskkill /f /im WinServiceUpdate.exe >nul 2>&1
taskkill /f /im wscript.exe >nul 2>&1

echo [+] Removing Persistent Tasks...
schtasks /delete /tn "WinServiceUpdate" /f >nul 2>&1
schtasks /delete /tn "WinServiceUpdate_Startup" /f >nul 2>&1

echo [+] Unlocking Folders...
:: Take ownership and grant Full Control to Administrators to bypass the DENY locks
takeown /f "%target%" /r /d y >nul 2>&1
icacls "%target%" /grant Administrators:F /t >nul 2>&1
attrib -h -s -r "%target%" /s /d >nul 2>&1

echo [+] Wiping Files...
rd /s /q "%target%" >nul 2>&1

echo DONE! System Cleaned.
pause
