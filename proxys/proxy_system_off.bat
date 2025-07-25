@echo off
echo Disabling system proxy only...

REM Disable system proxy via registry
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f >nul
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /f >nul 2>nul

echo System proxy disabled
echo Note: You may need to restart browsers for changes to take effect
pause