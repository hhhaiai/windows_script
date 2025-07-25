# Windows 工具集

这是一套用于 Windows 系统的实用批处理脚本工具集，包含代理管理和 Git 自动化工具。

## Git 自动化工具

### gpp.bat - Git Push Plus
自动化 Git 提交和推送工具，按以下顺序执行：
1. 检查是否为 Git 仓库
2. 如果有未暂存的更改，执行 `git add .`
3. 如果有已暂存但未提交的更改，执行 `git commit -m "update by gpp yyyy-mm-dd hh:mm:ss"`
4. 如果有未推送的提交，执行 `git push`

**使用方法**：在 Git 仓库目录下双击运行 `gpp.bat`

## 代理管理工具

这是一套用于 Windows 系统的代理管理批处理脚本，支持多种应用和服务的代理设置。
