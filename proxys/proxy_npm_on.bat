@echo off
echo Setting npm/yarn proxy only...

REM npm proxy
echo Setting npm proxy...
npm config set proxy http://127.0.0.1:7890
npm config set https-proxy http://127.0.0.1:7890
npm config set registry https://registry.npmjs.org/
echo npm proxy set successfully

REM yarn proxy (if yarn is installed)
echo Setting yarn proxy...
yarn config set proxy http://127.0.0.1:7890 2>nul
yarn config set https-proxy http://127.0.0.1:7890 2>nul
if %errorlevel% equ 0 (
    echo yarn proxy set successfully
) else (
    echo yarn not found, skipping...
)

echo npm/yarn proxy enabled: 127.0.0.1:7890
pause