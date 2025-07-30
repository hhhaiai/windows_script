@echo off
echo Setting system proxy only...

REM Set system proxy via registry
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /t REG_SZ /d "127.0.0.1:7890" /f >nul

echo System proxy enabled: 127.0.0.1:7890
echo Note: You may need to restart browsers for changes to take effect
pause