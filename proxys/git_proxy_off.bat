@echo off
echo Removing Git proxy only...

git config --global --unset http.proxy
git config --global --unset https.proxy

echo Git proxy disabled
pause