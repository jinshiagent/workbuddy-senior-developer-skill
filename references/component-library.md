# FluxUI 组件库索引与标准用法

> 官方文档实时基准：`https://fluxui.dev/docs/components/<component-name>`
> Alpine.js 随 Livewire 自带，无需单独安装。
> 所有组件均为 Laravel Blade 组件，可直接与 `wire:*` 指令组合。

---

## 目录（快速索引）

| 分组 | 组件 |
|---|---|
| 排版 | `flux:heading` `flux:text` `flux:link` `flux:blockquote` `flux:code` `flux:kbd` |
| 布局 | `flux:container` `flux:card` `flux:separator` `flux:spacer` |
| 操作 | `flux:button` `flux:icon` `flux:dropdown` `flux:menu` `flux:modal` `flux:drawer` |
| 表单 | `flux:input` `flux:textarea` `flux:select` `flux:checkbox` `flux:radio` `flux:toggle` `flux:field` `flux:label` `flux:error` `flux:date-picker` |
| 导航 | `flux:nav` `flux:sidebar` `flux:aside` `flux:tabs` `flux:tab` `flux:command` `flux:breadcrumbs` |
| 反馈 | `flux:badge` `flux:avatar` `flux:tooltip` `flux:progress` `flux:callout` `flux:toast` |

---

## 1. 排版组件

### `flux:heading`
```html
<flux:heading size="lg" class="gradient-text">Premium Content</flux:heading>
<flux:heading level="2" size="xl">语义化二级标题</flux:heading>
```
- `size`：`xs sm base lg xl 2xl 3xl 4xl`（或数值等级）
- `level`：渲染的 `h1..h6` 语义层级（默认按 size 推断）

### `flux:text`
```html
<flux:text class="opacity-80">副文案，默认继承 muted 色调</flux:text>
<flux:text variant="strong">强调文本</flux:text>
```

### `flux:link`
```html
<flux:link href="/pricing" wire:navigate>Pricing</flux:link>
```
- 配合 `wire:navigate` 实现 SPA 无刷新跳转（Laravel Livewire v3）。

---

## 2. 布局组件

### `flux:container`
页面内容最大宽度容器（响应式居中）。
```html
<flux:container class="py-16">...</flux:container>
```

### `flux:card`
```html
<flux:card class="luxury-glass hover:scale-[1.02] transition-all duration-300">
    <flux:heading size="lg">会员权益</flux:heading>
    <flux:text class="opacity-80 mt-2">尊享专属服务与优先支持</flux:text>
</flux:card>
```
- `luxury-glass` 来自 `assets/premium-theme.css` 的玻璃拟态工具类。

### `flux:separator` / `flux:spacer`
```html
<flux:separator />
<flux:spacer />
```

---

## 3. 操作组件

### `flux:button`
```html
<flux:button variant="primary" size="md" icon="arrow-right" wire:click="subscribe">
    立即订阅
</flux:button>

<flux:button variant="ghost" size="sm" icon="heart" />
<flux:button variant="danger" wire:click="delete" wire:confirm="确定删除？">删除</flux:button>
```
- `variant`：`primary` `secondary` `ghost` `outline` `danger`
- `size`：`xs sm md lg xl`
- `icon`：图标名（来自 Flux icon 集）
- `wire:click` / `wire:confirm`：Livewire 行为

### `flux:icon`
```html
<flux:icon name="sparkles" class="size-5 text-emerald-400" variant="mini" />
```

### `flux:dropdown` + `flux:menu`
```html
<flux:dropdown>
    <flux:button icon="chevron-down" variant="ghost">菜单</flux:button>
    <flux:menu>
        <flux:menu.item icon="user">个人资料</flux:menu.item>
        <flux:menu.item icon="cog">设置</flux:menu.item>
        <flux:menu.separator />
        <flux:menu.item icon="arrow-right-start-on-rectangle" wire:click="logout">退出</flux:menu.item>
    </flux:menu>
</flux:dropdown>
```

### `flux:modal`
```html
<flux:modal name="contact" variant="bare" class="md:w-96">
    <flux:heading size="lg">联系我们</flux:heading>
    <flux:text class="mt-2">填写下方信息，我们会尽快回复。</flux:text>
    <flux:input wire:model="email" label="邮箱" type="email" class="mt-4" />
    <flux:button variant="primary" class="mt-4 w-full" wire:click="send">发送</flux:button>
</flux:modal>
```
- 通过 `wire:model="showModal"`（布尔属性）由 Livewire 控制开关。

### `flux:drawer`（移动端导航）
```html
<flux:drawer name="mobile-nav" class="bg-zinc-900! text-white">
    <flux:nav>...</flux:nav>
</flux:drawer>
```

---

## 4. 表单组件

### `flux:input`
```html
<flux:input
    wire:model.live="search"
    type="search"
    placeholder="搜索功能…"
    icon="magnifying-glass"
    clearable
    size="md"
/>
```

### `flux:textarea`
```html
<flux:textarea wire:model="message" placeholder="请输入反馈" rows="4" />
```

### `flux:select`
```html
<flux:select wire:model="plan" placeholder="选择套餐">
    <flux:select.option value="free">免费版</flux:select.option>
    <flux:select.option value="pro">专业版</flux:select.option>
    <flux:select.option value="enterprise">企业版</flux:select.option>
</flux:select>
```

### `flux:checkbox` / `flux:radio` / `flux:toggle`
```html
<flux:checkbox wire:model="agree" label="我已阅读条款" />
<flux:radio wire:model="gender" value="m" label="男" />
<flux:toggle wire:model="notify">开启通知</flux:toggle>
```

### `flux:field` + `flux:label` + `flux:error`（组合校验）
```html
<flux:field>
    <flux:label>邮箱</flux:label>
    <flux:input wire:model="email" type="email" />
    <flux:error>{{ $errors->first('email') }}</flux:error>
</flux:field>
```

### `flux:date-picker`
```html
<flux:date-picker wire:model="birthday" placeholder="选择日期" />
```

---

## 5. 导航组件

### `flux:nav` + `flux:nav.item`
```html
<flux:nav>
    <flux:nav.item icon="home" href="/" :active="request()->is('/')">首页</flux:nav.item>
    <flux:nav.item icon="squares-2x2" href="/features">功能</flux:nav.item>
    <flux:nav.item icon="envelope" href="/contact">联系</flux:nav.item>
</flux:nav>
```

### `flux:sidebar` + `flux:aside`
```html
<flux:sidebar class="luxury-glass">
    <flux:brand>吴八哥 Studio</flux:brand>
    <flux:nav>...</flux:nav>
</flux:sidebar>
```

### `flux:tabs` + `flux:tab`
```html
<flux:tabs>
    <flux:tab name="overview" icon="chart-bar">概览</flux:tab>
    <flux:tab name="billing" icon="credit-card">账单</flux:tab>
</flux:tabs>
```

### `flux:command`（命令面板）
```html
<flux:command>
    <flux:command.input placeholder="输入命令…" />
    <flux:command.item icon="plus">新建项目</flux:command.item>
</flux:command>
```

---

## 6. 反馈组件

### `flux:badge`
```html
<flux:badge variant="success" size="sm">已上线</flux:badge>
<flux:badge color="emerald" >Pro</flux:badge>
```

### `flux:avatar`
```html
<flux:avatar icon="user" size="sm" />
<flux:avatar src="{{ $user->avatar }}" />
```

### `flux:tooltip`
```html
<flux:tooltip>悬停查看说明</flux:tooltip>
```

### `flux:progress`
```html
<flux:progress value="{{ $percent }}" />
```

### `flux:callout`
```html
<flux:callout icon="information-circle" variant="info">
    本功能处于灰度发布阶段。
</flux:callout>
```

---

## 7. 高频组合范式（Premium Pattern）

**玻璃拟态卡片 + 徽章 + 磁力悬停**
```html
<flux:card class="luxury-glass magnetic transition-transform duration-300 hover:scale-[1.03]">
    <div class="flex items-center justify-between">
        <flux:heading size="lg">企业版</flux:heading>
        <flux:badge color="emerald">推荐</flux:badge>
    </div>
    <flux:text class="opacity-80 mt-2">无限项目 + 优先支持</flux:text>
    <flux:button variant="primary" class="mt-4 w-full" wire:click="choose('enterprise')">
        选择套餐
    </flux:button>
</flux:card>
```

**模态表单（Livewire 驱动）**
```html
<flux:modal name="subscribe" wire:model="showSubscribe">
    <flux:heading size="lg">订阅更新</flux:heading>
    <flux:input wire:model="email" label="邮箱" type="email" class="mt-4" />
    <flux:error>{{ $errors->first('email') }}</flux:error>
    <flux:button variant="primary" class="mt-4 w-full" wire:click="subscribe">提交</flux:button>
</flux:modal>
```
