@echo off
setlocal
echo GPP - 极简Git自动化工具
echo 正在执行提交检查...

:: 1. 提交所有变更（仅当有修改时）
git diff --quiet --exit-code || (
    git add . 
    git commit -am "update %date% %time%" >nul && echo 变更已提交
)

:: 2. 推送所有提交（智能处理首次推送）
git rev-parse --abbrev-ref @{u} >nul 2>&1 && (
    git push 2>&1 | find "Everything up-to-date" >nul || (git push && echo 推送完成)
) || (
    git push -u origin HEAD && echo 首次推送完成
)

echo 操作完成！
pause