@echo off
setlocal enabledelayedexpansion

:: ============================================================================
:: GPP - The Final Version (v6.0)
:: Developed with invaluable user feedback.
:: This version uses in-memory processing and avoids all temporary files.
:: ============================================================================

echo GPP - Git Push Plus (Version 6.0 - Final)

:: --- Part 1: Commit local changes (if any) ----------------------------------
echo(
echo [1/2] Checking for local changes...

git diff HEAD --quiet --exit-code
if %errorlevel% neq 0 (
    echo      -> Uncommitted changes detected. Proceeding with auto-commit.
    :: Removed the problematic '!' character entirely for maximum compatibility.
    echo      -> Using generic commit message "chore: auto-update".
    git add .
    git commit -m "chore: auto-update" >nul 2>&1
    echo      -> Changes committed successfully.
) else (
    echo      -> No local changes to commit.
)

:: --- Part 2: Push commits to remote (if ahead) ------------------------------
echo(
echo [2/2] Checking for commits to push...

for /f %%i in ('git rev-parse --abbrev-ref HEAD') do set "CURRENT_BRANCH=%%i"

git config "branch.!CURRENT_BRANCH!.remote" >nul 2>&1
if %errorlevel% neq 0 (
    echo      -> No upstream branch configured. Attempting initial push...
    git push --set-upstream origin !CURRENT_BRANCH!
) else (
    :: THE CORE FIX: Process command output in-memory without temp files.
    :: Initialize 'ahead' count to 0.
    set "ahead=0"

    :: Use a 'for /f' loop with an escaped pipe ('^|') to capture the output
    :: of 'git status' after filtering it with 'findstr'.
    :: This is the most robust method available in pure Batch.
    for /f "tokens=3" %%a in ('git status --porcelain=v2 --branch ^| findstr "# branch.ab"') do (
        :: The token will be something like "+1". We need the number.
        set "ahead_raw=%%a"
        :: Remove the '+' sign using string substitution.
        set "ahead=!ahead_raw:+=!"
    )

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
