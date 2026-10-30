# senior-developer · 高级全栈开发工程师技能包

> 把"做一个网站 / 加个功能 / 优化体验"转化为**像素级打磨、动效与性能并存、可立即上线**的 premium 全栈实现。
> 专精：Laravel / Livewire / FluxUI · 高级 CSS（玻璃拟态/微交互）· Three.js（粒子/3D）。

---

## 一、功能特性（v1.0.0）

- 🎨 **奢华样式规范**：统一设计 Token、1.25 排版比例、8px 间距栅格、玻璃拟态配方与调参。
- 💎 **FluxUI 组件索引**：覆盖排版/布局/操作/表单/导航/反馈 6 大类组件的标准用法与高频组合。
- ⚡ **高性能动效**：GPU 友好的 `transform/opacity` 动效、premium 减速曲线、60fps 预算拆解。
- 🌌 **Three.js 粒子模板**：自包含 Hero 粒子场（BufferGeometry + Points），含降级与离屏暂停。
- 🔗 **Livewire + Alpine 模式**：服务端状态/纯前端微交互协同、组件事件通信、表单校验。
- 🌗 **三色主题**：light / dark / system 瞬时切换，首屏防闪烁。
- ♿ **质量闸门**：响应式、性能预算（首屏 < 1.5s）、WCAG 2.1 AA、`prefers-reduced-motion` 降级。

---

## 二、包结构

```
workbuddy-senior-developer-skill/        # 仓库根目录（克隆后以此命名）
├── SKILL.md                         # 主入口：frontmatter + 身份/哲学/强制规则/流程/沟通风格
├── references/
│   ├── component-library.md          # FluxUI 组件索引与标准用法
│   ├── premium-style-guide.md        # 奢华样式规范（玻璃拟态/排版/间距）
│   ├── advanced-tech-patterns.md     # Three.js 粒子 + 高级 CSS 动效性能优化
│   └── laravel-livewire-patterns.md  # Livewire + Alpine + Laravel 状态同步与通信
├── assets/
│   ├── premium-theme.css             # 可复用主题 Token + 玻璃拟态工具类（含 Tailwind 扩展片段）
│   └── hero-threejs.html             # 自包含 Three.js 粒子 Hero 模板（双击预览）
├── install.sh                       # 一键安装（macOS / Linux）
├── install.ps1                      # 一键安装（Windows PowerShell）
├── package.py                       # 跨平台打包脚本（生成分发 zip）
├── package.sh                       # 打包入口（macOS / Linux）
├── package.ps1                      # 打包入口（Windows PowerShell）
├── LICENSE                          # MIT 许可证
├── .gitignore                       # 忽略 dist/ 等构建产物
└── README.md                        # 本文件
```

---

## 三、依赖说明（Dependencies）

本技能是**方法论与资产包**，运行时依赖取决于你要构建的项目类型：

| 依赖 | 版本要求 | 用途 | 安装方式 |
|---|---|---|---|
| `tailwind` | >= 3.4 | 原子化样式基础（FluxUI 依赖 Tailwind） | `npm i -D tailwindcss` |
| `laravel` | >= 10.0 | 后端框架、路由、模型、校验 | `composer create-project laravel/laravel` |
| `livewire` | >= 3.0 | 服务端驱动的全栈组件（自带 Alpine.js） | `composer require livewire/livewire` |
| `threejs` | >= 0.160.0 | WebGL 粒子/3D 视觉 | `npm i three` |

> **注意**：Alpine.js **随 Livewire 自带**，请勿单独 `npm install alpinejs`。
> FluxUI 为商业/授权组件库，请遵循其官方许可安装（`composer require fluxui/flux` 或对应渠道），并以 `https://fluxui.dev/docs/components/<name>` 为 API 实时基准。

`assets/hero-threejs.html` 采用 **CDN（jsDelivr ESM importmap）** 引入 Three.js，双击即可在浏览器预览（需联网；离线时自动降级为 CSS 渐变背景）。

---

## 四、安装与分发

### 方式 A：直接安装（用户级，立即可用）
将 `senior-developer/` 整个目录解压/复制到：
```
~/.workbuddy/skills/senior-developer/
```
（Windows 路径：`C:\Users\<你的用户名>\.workbuddy\skills\senior-developer\`）
重启或刷新 WorkBuddy 后，即可用 `/senior-developer` 调用。

### 方式 B：项目级（团队共享）
复制到项目内：
```
<你的项目>/.workbuddy/skills/senior-developer/
```
仅对当前项目生效，便于随仓库分发。

### 方式 C：从发布包安装
1. 获取 `senior-developer.zip`（本仓库 Release 附件）。
2. 解压得到 `senior-developer/` 文件夹。
3. 按方式 A 或 B 放入对应 `skills/` 目录。

### 方式 D：一键脚本安装（推荐）
克隆仓库后，运行对应脚本即可自动复制到用户级技能目录：
```bash
# macOS / Linux
bash install.sh

# Windows (PowerShell)
.\install.ps1
```
脚本会把 `SKILL.md` / `references/` / `assets/` / `README.md` 复制到 `~/.workbuddy/skills/senior-developer/`（Windows 为目标用户目录），安装后刷新 WorkBuddy 输入 `/senior-developer` 即可。

### 验证安装
- 确认 `SKILL.md` 存在且 frontmatter 含 `name: senior-developer`。
- 在 WorkBuddy 中输入 `/senior-developer`，应触发角色卡输出（身份 + 技术栈 + 强制规则摘要）。

---

## 五、快速使用

1. 调用 `/senior-developer`，描述你的 premium 网页/全栈需求。
2. 技能按"分析 → 实现 → QA"流程交付，并复用：
   - `assets/premium-theme.css` —— 设计 Token 与玻璃拟态工具类（直接 `@import` 或照搬 Tailwind 扩展）。
   - `references/component-library.md` —— 选取 FluxUI 组件组合。
   - `references/advanced-tech-patterns.md` + `assets/hero-threejs.html` —— 接入 Three.js 粒子 Hero。
   - `references/laravel-livewire-patterns.md` —— 落地 Livewire/Alpine 状态与通信。
3. 交付时附带 enhancement 笔记与性能/可访问性自检结论。

---

## 六、打包为分发 zip

仓库提供跨平台打包脚本，将技能内容压缩为 `dist/senior-developer.zip`（解压后顶层为 `senior-developer/`，可直接放入 `skills` 目录）：

```bash
# macOS / Linux
bash package.sh
# 或
python3 package.py

# Windows (PowerShell)
.\package.ps1
# 或
python package.py
```

生成的 `dist/senior-developer.zip` 即标准分发包，可上传至 GitHub Release 或分享给他人。

## 七、Release Notes — v1.0.0（首发）

**发布日期**：2026-10-30
**类型**：首发稳定版（Stable）
**维护者**：WorkBuddy Skill Creator · License: MIT

### ✨ 新增（Added）
- 主入口 `SKILL.md`：定义高级全栈开发工程师身份、开发哲学、4 条强制质量闸门（三色主题 / 响应式 / 性能预算 / WCAG 2.1 AA）、三步实现流程与沟通风格。
- `references/component-library.md`：FluxUI 6 大类组件索引（排版/布局/操作/表单/导航/反馈）含标准用法示例与 2 个 premium 组合范式。
- `references/premium-style-guide.md`：双主题设计 Token、1.25 排版比例、8px 间距栅格、玻璃拟态调参与避坑、无闪烁主题切换实现、磁力悬停。
- `references/advanced-tech-patterns.md`：Three.js 粒子场（BufferGeometry+Points）集成范式、GPU 友好动效法则、60fps 预算拆解、关键帧曲线、视差与资源加载优化。
- `references/laravel-livewire-patterns.md`：Livewire 组件骨架、数据绑定生命周期、事件通信（`dispatch`/`#[On]`/`$dispatch`）、Alpine 微交互、表单服务端校验、持久化与会话。
- `assets/premium-theme.css`：即用的明暗 Token + `.luxury-glass` 等玻璃工具类 + 渐变文字/磁力悬停/入场动画 + `prefers-reduced-motion` 降级 + Tailwind 扩展片段。
- `assets/hero-threejs.html`：自包含 Three.js 粒子 Hero（CDN ESM、WebGL 检测降级、离屏暂停、`resize` 自适应、主题色随切换）。

### 🔒 强制约束（Enforced）
- 每个站点必须实现 light/dark/system 三态主题切换，且首屏无闪烁。
- 动画仅 `transform`/`opacity`，稳定 60fps；首屏可交互 < 1.5s。
- 响应式覆盖 360/768/1280；触控目标 ≥ 44px。
- 对比度 ≥ 4.5:1；键盘可达；动效尊重 `prefers-reduced-motion`。
- Alpine.js 不得单独安装（随 Livewire 自带）。

### 📌 已知范围（Scope）
- FluxUI 为独立授权组件库，本包提供用法范式与官方文档基准，不包含其商业源码。
- `hero-threejs.html` 依赖 CDN，离线预览将降级为 CSS 渐变背景。

### 🗺️ 后续路线（Roadmap）
- 增加更多 FluxUI 组件实时示例（图表/日历/命令面板深度集成）。
- 增加可运行的 Laravel 演示脚手架（一键 `composer create-project` 模板）。
- 沉淀更多 premium 动效曲线与 Three.js 展示范式到 `references/`。

---

## 八、许可证

MIT License. 自由使用、修改与再分发，请保留原作者与许可证声明。
