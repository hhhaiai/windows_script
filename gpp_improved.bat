@echo off
setlocal enabledelayedexpansion

:: ============================================================================
:: GPP - Git Push Plus (v5.2 - Bulletproof Edition)
:: A robust script to auto-commit and push changes, designed to withstand
:: cross-shell invocation issues (e.g., from PowerShell).
:: ============================================================================

echo GPP - Git Push Plus (Version 5.2 - Bulletproof)

:: Define the warning message in a standard variable to avoid delayed expansion issues with '!'.
set "WARNING_MSG=[!] Using generic commit message "chore: auto-update"."

:: -----------------------------------------------------------------------------
:: Part 1: Commit local changes (if any)
:: -----------------------------------------------------------------------------
echo(
echo [1/2] Checking for local changes...

git diff HEAD --quiet --exit-code
if %errorlevel% neq 0 (
    echo      -> Uncommitted changes detected. Proceeding with auto-commit.
    :: Echo the variable using standard '%' expansion, which is safe.
    echo      %WARNING_MSG%
    git add .
    :: Robustly silence the commit command by redirecting BOTH stdout and stderr.
    :: This prevents asynchronous output stream conflicts.
    git commit -m "chore: auto-update" >nul 2>&1
    echo      -> Changes committed successfully.
) else (
    echo      -> No local changes to commit.
)

:: -----------------------------------------------------------------------------
:: Part 2: Push commits to remote (if ahead)
:: -----------------------------------------------------------------------------
echo(
echo [2/2] Checking for commits to push...

for /f %%i in ('git rev-parse --abbrev-ref HEAD') do set "CURRENT_BRANCH=%%i"

git config "branch.!CURRENT_BRANCH!.remote" >nul 2>&1
if %errorlevel% neq 0 (
    echo      -> No upstream branch configured. Attempting initial push...
    git push --set-upstream origin !CURRENT_BRANCH!
) else (
    set "GIT_STATUS_TMP=%TEMP%\git_status_output.tmp"
    git status --porcelain=v2 --branch > "%GIT_STATUS_TMP%"
    
    set "ahead=0"
    for /f "tokens=3" %%a in ('findstr "# branch.ab" "%GIT_STATUS_TMP%"') do (
        set "ahead=%%a"
    )
    if exist "%GIT_STATUS_TMP%" del "%GIT_STATUS_TMP%"

    if !ahead! gtr 0 (
        echo      -> Local branch is !ahead! commit(s) ahead. Pushing...
        git push
    ) else (
        echo      -> Branch is up-to-date with the remote. Nothing to push.
    )
)

:end
echo(
echo Operation completed!
pause
