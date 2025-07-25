@echo off
echo Removing npm/yarn proxy only...

REM npm proxy
echo Removing npm proxy...
npm config delete proxy 2>nul
npm config delete https-proxy 2>nul
npm config set registry https://registry.npmjs.org/
echo npm proxy removed successfully

REM yarn proxy (if yarn is installed)
echo Removing yarn proxy...
yarn config delete proxy 2>nul
yarn config delete https-proxy 2>nul
if %errorlevel% equ 0 (
    echo yarn proxy removed successfully
) else (
    echo yarn not found, skipping...
)

echo npm/yarn proxy disabled
pause