@echo off
echo Disabling proxy for all services...
echo.

REM Git proxy
echo [1/4] Removing Git proxy...
git config --global --unset http.proxy
git config --global --unset https.proxy
echo Git proxy removed successfully

REM npm proxy
echo [2/4] Removing npm proxy...
npm config delete proxy 2>nul
npm config delete https-proxy 2>nul
npm config set registry https://registry.npmjs.org/
echo npm proxy removed successfully

REM yarn proxy (if yarn is installed)
echo [3/4] Removing yarn proxy...
yarn config delete proxy 2>nul
yarn config delete https-proxy 2>nul
if %errorlevel% equ 0 (
    echo yarn proxy removed successfully
) else (
    echo yarn not found, skipping...
)

REM System proxy (Windows registry)
echo [4/4] Disabling system proxy...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f >nul
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /f >nul 2>nul
echo System proxy disabled successfully

echo.
echo All proxies have been disabled successfully!
pause