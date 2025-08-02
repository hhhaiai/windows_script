@echo off
setlocal enabledelayedexpansion

:: ============================================================================
:: GPP - Git Push Plus (v5.1 - Final)
:: A robust script to auto-commit and push changes.
:: ============================================================================

echo GPP - Git Push Plus (Version 5.1 - Final)

:: -----------------------------------------------------------------------------
:: Part 1: Commit local changes (if any)
:: -----------------------------------------------------------------------------
echo(
echo [1/2] Checking for local changes...

:: A single, robust command to check for ANY uncommitted changes.
git diff HEAD --quiet --exit-code
if %errorlevel% neq 0 (
    echo      -> Uncommitted changes detected. Proceeding with auto-commit.
    :: Correctly escape the '!' character for echo when delayed expansion is on.
    echo      [^!] Using generic commit message "chore: auto-update".
    git add .
    git commit -m "chore: auto-update" >nul
    echo      -> Changes committed successfully.
) else (
    echo      -> No local changes to commit.
)

:: -----------------------------------------------------------------------------
:: Part 2: Push commits to remote (if ahead)
:: -----------------------------------------------------------------------------
echo(
echo [2/2] Checking for commits to push...

:: Get the current branch name
for /f %%i in ('git rev-parse --abbrev-ref HEAD') do set "CURRENT_BRANCH=%%i"

:: Robustly check if the current branch has a configured upstream remote.
git config "branch.!CURRENT_BRANCH!.remote" >nul 2>&1
:: Correct Batch syntax: use parentheses () for code blocks, not braces {}.
if %errorlevel% neq 0 (
    echo      -> No upstream branch configured. Attempting initial push...
    git push --set-upstream origin !CURRENT_BRANCH!
) else (
    :: Get ahead/behind counts using the stable temp file method.
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
