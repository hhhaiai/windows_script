@echo off
setlocal enabledelayedexpansion

echo GPP - Git Push Plus (Final Version)

:: -----------------------------------------------------------------------------
:: Part 1: Commit local changes (if any)
:: -----------------------------------------------------------------------------
echo Checking for local changes...

:: Check for any staged or modified files.
git diff --quiet --cached --exit-code && git diff --quiet --exit-code
if %errorlevel% neq 0 (
    echo.
    echo [INFO] Changes detected. Proceeding with commit.
    echo [WARNING] Using generic commit message "chore: auto-update". For meaningful history, consider committing manually.
    echo [WARNING] Ensure .gitignore is configured to avoid committing unwanted files.
    echo.
    git add .
    git commit -m "chore: auto-update" >nul
    if !errorlevel! equ 0 (
        echo Changes committed successfully.
    ) else (
        echo Commit step resulted in no changes (perhaps only untracked files were added). Continuing...
    )
) else (
    echo No local changes to commit.
)

:: -----------------------------------------------------------------------------
:: Part 2: Push commits to remote (if ahead)
:: -----------------------------------------------------------------------------
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
    for /f "tokens=3" %%a in ('git status --porcelain=v2 --branch ^| findstr "# branch.ab"') do (
        set "ahead=%%a"
    )

    :: The 'ahead' variable will contain "+N", which works directly in IF comparison
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
