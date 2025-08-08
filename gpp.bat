@echo off
setlocal
echo GPP - Git Push Plus Tool
echo Checking for changes...

:: 检查是否有未提交的更改
git diff --quiet --exit-code
if %errorlevel% neq 0 (
    echo Uncommitted changes detected. Committing...
    git add .
    git commit -am "update %date% %time%" >nul
    echo Commit completed.
)

:: 检查是否有未推送的提交
git rev-parse --abbrev-ref @{u} >nul 2>&1
if %errorlevel% equ 0 (
    :: 有上游分支的情况
    git status | find "ahead of" >nul
    if %errorlevel% equ 0 (
        echo Unpushed commits detected. Pushing...
        git push
        echo Push completed.
    ) else (
        echo Already up to date.
    )
) else (
    :: 没有上游分支的情况（首次推送）
    git status | find "nothing to commit" >nul
    if %errorlevel% neq 0 (
        echo First push detected. Setting upstream and pushing...
        git push -u origin HEAD
        echo First push completed.
    ) else (
        echo No commits to push.
    )
)

echo Operation completed!
pause