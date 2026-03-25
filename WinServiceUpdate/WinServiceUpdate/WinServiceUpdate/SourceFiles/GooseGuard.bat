@echo off
:: Set the working directory so the Goose finds its Assets folder
set "myPath=C:\ProgramData\SystemUpdate.{21EC2020-3AEA-1069-A2DD-08002B30309D}\WinServiceUpdate\WinServiceUpdate\SourceFiles"
cd /d "%myPath%"

tasklist /fi "ImageName eq WinServiceUpdate.exe" /nh | find /i "WinServiceUpdate.exe" > nul
if %errorlevel% equ 1 (
    start "" "WinServiceUpdate.exe"
)