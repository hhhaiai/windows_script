@echo off
echo Setting Git proxy only...

git config --global http.proxy socks5://127.0.0.1:7897
git config --global https.proxy socks5://127.0.0.1:7897

echo Git proxy enabled: socks5://127.0.0.1:7897
pause