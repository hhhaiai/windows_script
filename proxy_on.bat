@echo off
echo Setting up proxy for all services...
echo.

REM Git proxy
echo [1/4] Setting Git proxy...
git config --global http.proxy socks5://127.0.0.1:7890
git config --global https.proxy socks5://127.0.0.1:7890
echo Git proxy set successfully

REM npm proxy
echo [2/4] Setting npm proxy...
npm config set proxy http://127.0.0.1:7890
npm config set https-proxy http://127.0.0.1:7890
npm config set registry https://registry.npmjs.org/
echo npm proxy set successfully

REM yarn proxy (if yarn is installed)
echo [3/4] Setting yarn proxy...
yarn config set proxy http://127.0.0.1:7890 2>nul
yarn config set https-proxy http://127.0.0.1:7890 2>nul
if %errorlevel% equ 0 (
    echo yarn proxy set successfully
) else (
    echo yarn not found, skipping...
)

REM System proxy (Windows registry)
echo [4/4] Setting system proxy...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /t REG_SZ /d "127.0.0.1:7890" /f >nul
echo System proxy set successfully

echo.
echo All proxies have been set successfully!
echo Proxy server: 127.0.0.1:7890
pause