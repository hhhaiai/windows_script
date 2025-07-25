@echo off
echo Quick cleanup - Disabling all proxies...

REM Git
git config --global --unset http.proxy 2>nul
git config --global --unset https.proxy 2>nul

REM npm
npm config delete proxy 2>nul
npm config delete https-proxy 2>nul

REM yarn
yarn config delete proxy 2>nul
yarn config delete https-proxy 2>nul

REM System
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f >nul

echo All proxies cleared!
timeout /t 2 >nul