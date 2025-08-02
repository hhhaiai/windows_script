@echo off
setlocal enabledelayedexpansion

echo GPP - Git Push Plus (Version 4 - Final)

:: -----------------------------------------------------------------------------
:: Part 1: Commit local changes (if any)
:: -----------------------------------------------------------------------------
echo Checking for local changes...

:: A single, robust command to check if there are ANY uncommitted changes (staged or unstaged)
git diff HEAD --quiet --exit-code
if %errorlevel% neq 0 (
    echo.
    echo [INFO] Uncommitted changes detected. Proceeding with auto-commit.
    echo [WARNING] Using generic commit message "chore: auto-update". For meaningful history, consider committing manually.
    echo.
    git add .
    git commit -m "chore: auto-update" >nul
    echo Changes committed successfully.
) else (
    echo No local changes to commit.
)

:: -----------------------------------------------------------------------------
:: Part 2: Push commits to remote (if ahead)
:: -----------------------------------------------------------------------------
echo.
echo Checking for commits to push...

:: Check if upstream branch is configured
git rev-parse --abbrev-ref @{u} >nul 2>&1
if %errorlevel% neq 0 (
    echo No upstream branch configured. Attempting initial push...
    for /f %%i in ('git rev-parse --abbrev-ref HEAD') do (
        git push --set-upstream origin %%i
    )
) else (
    :: Check if local branch is ahead of remote
    git status | find "ahead of" >nul
    if !errorlevel! equ 0 (
        echo Local branch has unpushed commits. Pushing...
        git push
        if !errorlevel! equ 0 (
            echo Push completed successfully.
        ) else (
            echo Push failed. Please check your network connection and permissions.
        )
    ) else (
        echo Branch is up-to-date with the remote. Nothing to push.
    )
)

:end
echo.
echo Operation completed!
pause
