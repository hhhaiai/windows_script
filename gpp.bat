@echo off
setlocal
echo GPP - Git Push Plus Tool
echo Checking for changes...

:: 1. Commit all changes (only when modified)
git diff --quiet --exit-code || (
    git add . 
    git commit -am "update %date% %time%" >nul && echo Changes committed
)

:: 2. Push all commits (smart handling for first push)
git rev-parse --abbrev-ref @{u} >nul 2>&1 && (
    git status | find "ahead of" >nul && (git push && echo Push completed) || echo Already up to date
) || (
    git push -u origin HEAD && echo First push completed
)

echo Operation completed!
pause