@echo off
setlocal enabledelayedexpansion

:: 检查 GITHUB_TOKEN 是否设置
if "%GITHUB_TOKEN%"=="" (
    echo Error: GITHUB_TOKEN environment variable is not set.
    exit /b 1
)

:: 初始化参数处理
set "args="
set "url_found=0"

:: 遍历所有参数
:parse_args
if "%~1"=="" goto execute
set "current=%~1"

:: 检查是否是 URL (HTTPS 或 SSH)
if !url_found! equ 0 (
    echo %current% | findstr /b "https://" >nul
    if !errorlevel! equ 0 (
        :: 处理 HTTPS URL
        echo %current% | findstr "@" >nul
        if !errorlevel! equ 0 (
            :: 已包含认证信息，直接使用
            set "args=!args! %current%"
        ) else (
            :: 插入 GITHUB_TOKEN
            set "modified_url=https://%GITHUB_TOKEN%@%current:~8%"
            set "args=!args! !modified_url!"
        )
        set "url_found=1"
        shift
        goto parse_args
    )

    echo %current% | findstr /b "git@" >nul
    if !errorlevel! equ 0 (
        :: SSH URL 直接使用
        set "args=!args! %current%"
        set "url_found=1"
        shift
        goto parse_args
    )
)

:: 添加非 URL 参数
set "args=!args! %current%"
shift
goto parse_args

:execute
:: 执行 git clone 命令
git clone !args!
endlocal