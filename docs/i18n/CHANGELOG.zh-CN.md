# 更新日志

ddagent 的所有重要变更都记录在此。

格式遵循 [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)，
本项目遵循 [Semantic Versioning](https://semver.org/)。

<p>
  <a href="../../CHANGELOG.md">English</a> ·
  <a href="CHANGELOG.pl.md">Polski</a> ·
  <a href="CHANGELOG.de.md">Deutsch</a> ·
  <a href="CHANGELOG.es.md">Español</a> ·
  <a href="CHANGELOG.fr.md">Français</a> ·
  <a href="CHANGELOG.it.md">Italiano</a> ·
  <a href="CHANGELOG.ja.md">日本語</a> ·
  <a href="CHANGELOG.ko.md">한국어</a> ·
  <a href="CHANGELOG.ru.md">Русский</a> ·
  <a href="CHANGELOG.tr.md">Türkçe</a> ·
  <strong>简体中文</strong> ·
  <a href="CHANGELOG.zh-TW.md">繁體中文</a>
</p>

## [0.6.0] - 2026-09-26

### 新增功能

- **Auto 编排提供方** — 模型路由、规划器 DAG 和委派；聊天中提供路由/计划/委派/摘要卡片，设置中新增编排选项卡
- **移动端：全面原生化** — 所有屏幕均已原生实现：Files（CRUD、搜索、灯箱）、Source Control（代码块暂存、分栏 diff、提交图、工作树）、Tasks（PRD 编辑器、详情编辑）、Agent Board、Quota & Usage、终端、编辑器和所有设置选项卡
- **移动端：** 引导向导、项目创建向导（文件夹浏览器、GitHub 克隆、检查）、带全局搜索的命令面板、分屏工作区网格、快捷设置面板、browser-use 实时面板
- **移动端：** 离线消息队列、聊天导出（PDF/md/html/text）、对话记录搜索、会话比较

### 问题修复

- OpenCode：流式文本快照导致会话行重复，question 工具提示未显示
- 固定的 Review/Search 栏遮挡第一条消息

## [0.5.9] - 2026-09-25

首个公开开源版本 — **AGPL-3.0-only**。

### 新增功能

- **团队协作** — 共享会话、广播消息、代理收件箱、按项目共享记忆
- **MCP 服务器** — 外部 MCP 客户端（Claude Desktop、OpenClaw）可通过 `POST /mcp` 创建任务并向会话发送消息（[文档](https://github.com/Zakwei/ddagent/blob/main/docs/mcp-server.md)）
- **远程审批** — 从 Telegram 或 Discord 批准代理操作（[文档](https://github.com/Zakwei/ddagent/blob/main/docs/remote-approvals.md)）
- **调度器** — 带防睡眠功能的代理运行 cron 计划
- **命名提供方账户** — 按会话覆盖环境变量/凭据
- **语音输入（STT）** — 输入框中的 Whisper 兼容端点
- **工作树** — 带 dev-server 运行器的按仓库设置/运行脚本
- **预览** — 带 WS 隧道的经身份验证 dev-server 预览代理
- **移动端** — 会话搜索、可操作的审批推送通知（FCM）
- `SECURITY.md` — 私密漏洞报告政策

### 问题修复

- 配额选项卡的数据和显示错误
- 聊天：离线队列和草稿在重新加载后保留；重新获取时滚动位置稳定
- 会话：已删除的会话不再在其他客户端留下残留
- 看板：代理面板上的派发竞态和泄漏
- 移动端：原始键盘高度内边距，用 ActionSheet 替换溢出警报

## [0.5.8] - 2026-09-23

### 新增功能

- `install.sh` — 基于 git 的服务器安装程序（`--version`、`--dir`、`--port`、`--systemd`）
- 在 `v*` 标签上发布的独立和本地服务器 tarball

### 问题修复

- 移动键盘遮挡输入框和系统导航栏下的内容（Android）

## [0.5.7] - 2026-09-23

### 问题修复

- 桌面 CI 构建（包平台标志、原生重编译、冒烟测试超时）
- 聊天记录中流式助手消息重复

## [0.5.6] - 2026-09-23

### 问题修复

- 桌面 CI：缺少 Apple 密钥时 macOS 构建未签名、Windows 作用域包暂存

## [0.5.5] - 2026-09-23

### 新增功能

- **桌面应用（预览）** — 用于本地或远程服务器的 Electron 启动器、嵌入式后端、自动更新、dmg/NSIS/AppImage/deb 构建
- **移动应用（预览）** — Expo/React Native 伴侣：会话、带模型选择器和斜杠命令的聊天、终端、文件、设置 WebView
- 有未读输出的会话上的未读指示器；任务面板 ↔ 会话关联
- 聊天中的 KaTeX 和 Mermaid 岛

### 问题修复

- 移动视口的触摸目标和布局；命令面板、看板和设置优化

## [0.5.4] - 2026-09-21

### 新增功能

- 带全屏进度遮罩的重启服务器按钮（设置 → 关于）
- 设置 → 关于中的本地化 GitHub 发布更新日志
- 浏览器标签页标题中显示运行中的会话数
- 使用趋势图表的 Y 轴刻度和悬停提示

### 问题修复

- 打开模态框时触发设置自动保存；多行分屏中的紧凑聊天布局

## [0.5.3] - 2026-09-21

### 问题修复

- 更新可用对话框被侧边栏遮挡（portal 修复）

## [0.5.2] - 2026-09-21

### 问题修复

- 更新检查改为通过服务器进行

## [0.5.1] - 2026-09-21

### 新增功能

- 带一键自更新的更新可用徽章
- 按会话的朗读语音；语音选择器移至外观设置

### 问题修复

- 聊天横幅显示会话的实际提供方

## [0.5.0] - 2026-09-21

**ddagent** 的首个独立版本 — 面向 AI 编码代理的自托管 Web 和移动 UI。

### 亮点

- **多代理会话** — Claude Code、Codex、Cursor CLI、OpenCode 和 Devin 并排运行，支持实时流式传输和恢复
- **工作区布局** — 聊天、终端、浏览器和文件的分割窗格
- **文件浏览器和编辑器** — 在 UI 中浏览和编辑工作区
- **Git 面板** — 暂存、提交、差异、切换分支、管理工作树
- **任务面板** — 由 TaskMaster 驱动的看板；从 PRD 生成可执行任务
- **MCP 管理** — 跨代理添加和同步 MCP 服务器
- **技能浏览器** — 发现和管理代理技能
- **配额与用量** — 各代理的令牌用量和订阅限额
- **Browser-use** — 用于研究和测试的代理驱动浏览器会话
- **通知与 TTS** — 提醒和朗读回复
- **Docker 沙箱** — 实验性虚拟机管理程序隔离的代理运行
- **桌面伴侣** — macOS/Windows 可选 Electron 应用
- **i18n** — 11 种 UI 语言、明暗主题

### CLI

- `ddagent` / `ddagent start` — 启动服务器
- `ddagent status` — 显示配置和数据位置
- `ddagent version` / `ddagent help`
