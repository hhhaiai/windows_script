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
    :: Use the modern, script-friendly git status to check ahead/behind counts
    set "ahead=0"
    rem The findstr command must look for "# branch.ab"
    for /f "tokens=3" %%a in ('git status --porcelain=v2 --branch ^| findstr "# branch.ab"') do (
        set "ahead=%%a"
    )

    :: The 'ahead' variable will contain a number like "+1" or "+0". Batch's "if gtr" handles this correctly.
    if !ahead! gtr 0 (
        echo Local branch is !ahead! commit(s) ahead. Pushing...
        git push
    ) else (
        echo Branch is up-to-date with the remote. Nothing to push.
    )
)

:end
echo.
echo Operation completed!
pause
