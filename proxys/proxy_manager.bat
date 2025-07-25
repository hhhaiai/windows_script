@echo off
title Proxy Manager
color 0A

:menu
cls
echo ========================================
echo           PROXY MANAGER
echo ========================================
echo.
echo Current proxy status:
echo.

REM Check Git proxy status
for /f "tokens=*" %%i in ('git config --global --get http.proxy 2^>nul') do set git_proxy=%%i
if defined git_proxy (
    echo Git proxy: ENABLED ^(%git_proxy%^)
) else (
    echo Git proxy: DISABLED
)

REM Check npm proxy status
for /f "tokens=*" %%i in ('npm config get proxy 2^>nul') do set npm_proxy=%%i
if "%npm_proxy%"=="null" set npm_proxy=
if defined npm_proxy (
    echo npm proxy: ENABLED ^(%npm_proxy%^)
) else (
    echo npm proxy: DISABLED
)

REM Check system proxy status
for /f "tokens=3" %%i in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable 2^>nul ^| find "ProxyEnable"') do set sys_proxy=%%i
if "%sys_proxy%"=="0x1" (
    echo System proxy: ENABLED
) else (
    echo System proxy: DISABLED
)

echo.
echo ========================================
echo.
echo 1. Enable ALL proxies
echo 2. Disable ALL proxies
echo.
echo 3. Enable Git proxy only
echo 4. Disable Git proxy only
echo.
echo 5. Enable npm/yarn proxy only
echo 6. Disable npm/yarn proxy only
echo.
echo 7. Enable system proxy only
echo 8. Disable system proxy only
echo.
echo 9. Refresh status
echo 0. Exit
echo.
set /p choice=Please select an option (0-9): 

if "%choice%"=="1" call proxy_on.bat && goto menu
if "%choice%"=="2" call proxy_off.bat && goto menu
if "%choice%"=="3" call git_proxy_on.bat && goto menu
if "%choice%"=="4" call git_proxy_off.bat && goto menu
if "%choice%"=="5" call proxy_npm_on.bat && goto menu
if "%choice%"=="6" call proxy_npm_off.bat && goto menu
if "%choice%"=="7" call proxy_system_on.bat && goto menu
if "%choice%"=="8" call proxy_system_off.bat && goto menu
if "%choice%"=="9" goto menu
if "%choice%"=="0" exit

echo Invalid option, please try again...
timeout /t 2 >nul
goto menu