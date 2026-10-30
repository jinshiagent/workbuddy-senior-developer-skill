# 奢华样式规范（Premium Style Guide）

把"基础实现"与"奢华实现"区分开的关键，在于**统一的 Token 体系、克制的留白、精准的排版比例，以及恰到好处的玻璃拟态**。

---

## 1. 设计 Token（Design Tokens）

所有颜色、间距、圆角、阴影、模糊都必须以变量形式存在，**禁止散落硬编码**。基础变量见 `assets/premium-theme.css`。此处给出语义层约定。

### 1.1 颜色（明暗双主题）
| Token | Light | Dark | 用途 |
|---|---|---|---|
| `--bg` | `#f7f8fa` | `#0a0b0f` | 页面背景 |
| `--surface` | `#ffffff` | `#14161c` | 卡片/浮层 |
| `--text` | `#0f1115` | `#eef1f6` | 主文本 |
| `--text-muted` | `#5b6472` | `#9aa3b2` | 次级文本 |
| `--accent` | `#10b981` | `#34d399` | 强调/品牌（绿） |
| `--accent-2` | `#6366f1` | `#818cf8` | 第二强调（靛） |
| `--border` | `rgba(0,0,0,.08)` | `rgba(255,255,255,.10)` | 描边 |

### 1.2 排版比例（Type Scale）
采用 **1.25 大三度（Major Third）** 比例，保证层级清晰且不失精致。
```
--fs-xs:  0.75rem   (12px)
--fs-sm:  0.875rem  (14px)
--fs-base:1rem      (16px)
--fs-lg:  1.25rem   (20px)
--fs-xl:  1.563rem  (25px)
--fs-2xl: 1.953rem  (31px)
--fs-3xl: 2.441rem  (39px)
--fs-4xl: 3.052rem  (49px)
```
- 正文 `--fs-base`；标题逐级跃升；Hero 主标题可用 `--fs-4xl` 配合 `clamp()` 做流式缩放：
  `font-size: clamp(2.2rem, 5vw, 3.052rem);`

### 1.3 间距体系（8px 栅格）
所有 margin/padding/gap 走 8 的倍数：`4 / 8 / 16 / 24 / 32 / 48 / 64 / 96 / 128 px`。
- 卡片内边距 ≥ 24px；区块纵向间距 ≥ 64px；首屏上下留白 ≥ 96px。

### 1.4 圆角与模糊
- 卡片圆角 `--radius: 20px`；按钮 `--radius-btn: 12px`；胶囊 `--radius-pill: 999px`。
- 玻璃模糊 `--blur: 30px`；饱和 `--saturate: 180%`。

---

## 2. 像素级排版规则

1. **行高**：正文 `1.6`，标题 `1.15`，保证呼吸感。
2. **字重层级**：正文 400，小标题 500，大标题 600–700；避免全篇 700。
3. **字间距**：大标题 `letter-spacing: -0.02em`（收紧显高级）；全大写标签 `letter-spacing: 0.08em`。
4. **渐变文字**（品牌感）：
   ```css
   .gradient-text {
     background: linear-gradient(135deg, var(--accent), var(--accent-2));
     -webkit-background-clip: text;
     background-clip: text;
     color: transparent;
   }
   ```
5. **对齐与栅格**：内容最大宽度 1200px；多列卡片用 `gap-6` 以上，避免拥挤。

---

## 3. 高级玻璃拟态（Glassmorphism）配置指南

玻璃拟态 = **半透明背景 + 背景模糊 + 细描边 + 柔和阴影**。核心在 `assets/premium-theme.css` 的 `.luxury-glass`，此处给出调参与避坑。

### 3.1 标准配方
```css
.luxury-glass {
  background: color-mix(in srgb, var(--surface) 60%, transparent);
  backdrop-filter: blur(var(--blur)) saturate(var(--saturate));
  -webkit-backdrop-filter: blur(var(--blur)) saturate(var(--saturate));
  border: 1px solid var(--border);
  border-radius: var(--radius);
  box-shadow: 0 8px 32px rgba(0,0,0,.12);
}
```

### 3.2 调参原则
- **背景透明度**：浅色主题 0.6–0.75；深色主题 0.35–0.5（深底上更透更"空灵"）。
- **模糊半径**：20–30px 足够；超过 40px 收益递减且更耗 GPU。
- **描边**：必须存在，否则玻璃边缘"糊"；用 `var(--border)`，1px 即可。
- **阴影**：柔和大模糊，避免硬黑边。

### 3.3 性能与兼容性避坑
- `backdrop-filter` 只在元素**背后有内容**时才可见——玻璃卡必须浮于图像/渐变/另一层之上。
- 同一视口内玻璃层**不要嵌套超过 2 层**，否则模糊叠加掉帧。
- 对动效元素使用玻璃时，过渡只作用于 `transform`/`opacity`/`background-color`，**不要**对 `backdrop-filter` 做 transition。
- 检测 `prefers-reduced-motion` 时，降级为纯 `var(--surface)` 实底，去掉模糊。
- Safari 需要 `-webkit-backdrop-filter` 前缀（已含在 `.luxury-glass`）。

---

## 4. 明暗主题切换实现（无闪烁）

在 `</head>` 前内联同步脚本（首屏防 FOUC）：
```html
<script>
  (function () {
    const t = localStorage.getItem('theme');
    const sys = window.matchMedia('(prefers-color-scheme: dark)').matches;
    const dark = t === 'dark' || (!t && sys) || t === 'system' && sys;
    document.documentElement.classList.toggle('dark', dark);
  })();
</script>
```
切换器（Alpine 或 Livewire 控制 `localStorage` + `classList`）：
```html
<button @click="const d=document.documentElement.classList.toggle('dark');localStorage.setItem('theme',d?'dark':'light')"
        class="luxury-glass rounded-full p-2">
  <flux:icon :name="$dark ? 'sun' : 'moon'" />
</button>
```
- `system` 态：移除/不写 `dark` class，并在 `<head>` 监听 `matchMedia` change 实时跟随。

---

## 5. 微交互与磁力悬停

```css
.magnetic { transition: transform .3s cubic-bezier(.16,1,.3,1); }
.magnetic:hover { transform: scale(1.05) translateY(-2px); }
```
- 曲线 `cubic-bezier(.16,1,.3,1)`（easeOutExpo 近似）显"高级减速"质感。
- 避免在 `:hover` 上做 `box-shadow` 大范围重绘动画；改用 `transform` 位移 + 预置阴影。

---

## 6. 检查清单（交付前）

- [ ] 所有颜色/间距来自 Token，无散落硬编码
- [ ] 三色主题切换无闪烁、瞬时生效
- [ ] 玻璃层 ≤ 2 层，背后有内容支撑
- [ ] 排版比例 1.25，行高/字间距符合规则
- [ ] 动效仅 `transform`/`opacity`，曲线为 premium 减速
- [ ] `prefers-reduced-motion` 已降级
