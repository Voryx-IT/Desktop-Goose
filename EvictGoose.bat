@echo off
net session >nul 2>&1
if %errorLevel% neq 0 (echo [!] Run as Admin & pause & exit)

set "fakeID=SystemUpdate.{21EC2020-3AEA-1069-A2DD-08002B30309D}"
set "fullPath=C:\ProgramData\%fakeID%"

echo [1/4] Stopping Goose Process...
taskkill /f /t /im WinServiceUpdate.exe >nul 2>&1
schtasks /delete /tn "WinServiceUpdate" /f >nul 2>&1
schtasks /delete /tn "WinServiceUpdate_Startup" /f >nul 2>&1

echo [2/4] Forcing Ownership...
:: This is the 'Sledgehammer' - it forces the Admin to own the folder again
takeown /f "%fullPath%" /a /r /d y >nul 2>&1

echo [3/4] Breaking Permissions...
:: Grant Admins full control back
icacls "%fullPath%" /grant Administrators:(OI)(CI)F /t >nul 2>&1
:: Strip all Deny rules we set earlier
icacls "%fullPath%" /remove:d Administrators /t >nul 2>&1
icacls "%fullPath%" /remove:d %USERNAME% /t >nul 2>&1

:: Remove System/Hidden/Read-Only flags
attrib -h -s -r "%fullPath%" /s /d >nul 2>&1

echo [4/4] Erasing Evidence...
:: Use DEL first to be thorough, then RD
del /f /q /s "%fullPath%\*.*" >nul 2>&1
rd /s /q "%fullPath%" >nul 2>&1

echo.
if exist "%fullPath%" (
    echo [!] Clean failed - folder still locked.
) else (
    echo [SUCCESS] PC is clean. Goose evicted.
)
pause