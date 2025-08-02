@echo off
setlocal enabledelayedexpansion

echo GPP - Git Push Plus (DEBUG Version)

:: Define a temporary file for output
set "GIT_STATUS_TMP=%TEMP%\git_status_output.tmp"

:: -----------------------------------------------------------------------------
:: Part 1: Commit local changes (if any)
:: -----------------------------------------------------------------------------
echo Checking for local changes...

git diff HEAD --quiet --exit-code
if %errorlevel% neq 0 (
    echo.
    echo [INFO] Uncommitted changes detected. Proceeding with auto-commit.
    echo [WARNING] Using generic commit message "chore: auto-update".
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

git rev-parse --abbrev-ref @{u} >nul 2>&1
if %errorlevel% neq 0 (
    echo No upstream branch configured. Attempting initial push...
    for /f %%i in ('git rev-parse --abbrev-ref HEAD') do (
        git push --set-upstream origin %%i
    )
) else (
    :: --- ROBUST PUSH CHECK ---
    echo [DEBUG] Getting git status and writing to %GIT_STATUS_TMP%
    
    :: 1. Redirect full output to a temp file
    git status --porcelain=v2 --branch > "%GIT_STATUS_TMP%"
    
    :: [DEBUG] Show the full content of the temp file
    echo [DEBUG] --- Content of temp file START ---
    type "%GIT_STATUS_TMP%"
    echo [DEBUG] --- Content of temp file END ---

    set "ahead=0"
    
    :: 2. Use findstr on the file and process its output with FOR
    echo [DEBUG] Running findstr on the temp file.
    for /f "tokens=3" %%a in ('findstr "# branch.ab" "%GIT_STATUS_TMP%"') do (
        echo [DEBUG] Found line, token 3 is '%%a'.
        set "ahead=%%a"
    )

    echo [DEBUG] Value of 'ahead' after loop is: !ahead!

    if !ahead! gtr 0 (
        echo Local branch is !ahead! commit(s) ahead. Pushing...
        git push
    ) else (
        echo Branch is up-to-date with the remote. Nothing to push.
    )
)

:cleanup
:: Clean up the temporary file
if exist "%GIT_STATUS_TMP%" del "%GIT_STATUS_TMP%"
echo [DEBUG] Temp file cleaned up.

:end
echo.
echo Operation completed!
pause
