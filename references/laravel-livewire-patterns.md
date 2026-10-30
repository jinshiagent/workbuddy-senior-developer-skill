# Laravel + Livewire + Alpine 后端状态同步与组件通信模式

Livewire v3 负责**服务端状态与持久化**，Alpine.js（随 Livewire 自带）负责**纯前端微交互**。二者协同，避免写大量手写 JS。

---

## 1. Livewire 组件骨架

### 1.1 类（Class）
```php
<?php

namespace App\Livewire;

use Livewire\Component;
use Livewire\WithPagination;

class PremiumNavigation extends Component
{
    use WithPagination;

    public bool $mobileMenuOpen = false;   // 公共属性自动同步到前端
    public string $search = '';
    public int $count = 0;

    // 规则：所有需要前端可绑定的状态都声明为 public 属性

    public function mount(): void
    {
        $this->count = 0;
    }

    // wire:model 双向绑定的属性会自动更新并触发 render
    public function updatedSearch(string $value): void
    {
        // 每次 search 变化后执行（如防抖搜索）
    }

    public function toggleMenu(): void
    {
        $this->mobileMenuOpen = !$this->mobileMenuOpen;
    }

    public function increment(): void
    {
        $this->count++;
    }

    public function render()
    {
        return view('livewire.premium-navigation');
    }
}
```

### 1.2 视图（Blade）
```html
<div>
    <button wire:click="toggleMenu" class="md:hidden luxury-glass rounded-lg p-2">
        菜单
    </button>

    @if ($mobileMenuOpen)
        <flux:drawer name="mobile-nav">...</flux:drawer>
    @endif

    <input wire:model.live.debounce.300ms="search" placeholder="搜索…" />

    <span>计数：{{ $count }}</span>
    <flux:button wire:click="increment">+1</flux:button>
</div>
```

---

## 2. 数据绑定与更新生命周期

| 指令 | 作用 |
|---|---|
| `wire:model="prop"` | 失焦/变更后同步到服务端 |
| `wire:model.live="prop"` | 输入即时同步（每个按键） |
| `wire:model.live.debounce.300ms="prop"` | 防抖同步，适合搜索 |
| `wire:click="method"` | 调用服务端方法 |
| `wire:submit="save"` | 表单提交 |
| `wire:poll.2s` | 每 2s 轮询刷新 |

- 服务端方法结束会自动**重新渲染并增量更新 DOM**（Livewire 的 morph 算法）。
- 大列表用 `WithPagination` + `wire:paginate`，避免整表重渲染。

---

## 3. 组件间通信

### 3.1 事件派发（子 → 父 / 跨组件）
```php
// 子组件内
$this->dispatch('plan-chosen', plan: 'enterprise');

// 父组件监听
#[On('plan-chosen')]
public function handlePlan(string $plan): void
{
    $this->selectedPlan = $plan;
}
```
Blade 中前端监听（Alpine 互操作）：
```html
<div x-data @plan-chosen.window="selected = $event.detail.plan">
    ...
</div>
```

### 3.2 浏览器事件（Alpine `$dispatch`）
```html
<button x-data @click="$dispatch('plan-chosen', { plan: 'pro' })">选择 Pro</button>
```
- `$dispatch` 派发的 `CustomEvent` 可被 Livewire 的 `#[On('plan-chosen')]` 接收（detail 自动映射）。

### 3.3 显式刷新
```php
$this->dispatch('$refresh');           // 强制当前组件重渲染
$this->dispatch('refreshParent');       // 配合父组件 #[On]
```

---

## 4. Alpine.js 纯前端微交互（不碰服务端）

```html
<div x-data="{ open: false, copied: false }" class="relative">
    <button @click="open = !open" class="magnetic">更多</button>
    <div x-show="open" x-transition.opacity.scale.95 @click.outside="open = false">
        下拉内容
    </div>
    <button @click="navigator.clipboard.writeText('{{ $code }}'); copied = true; setTimeout(() => copied = false, 1500)">
        <span x-show="!copied">复制</span>
        <span x-show="copied">已复制</span>
    </button>
</div>
```
- `x-transition` 提供 GPU 友好的进入/离开（opacity + scale）。
- `@click.outside` 实现点击外部关闭。
- 纯前端状态（open/copied）不进 Livewire，减少服务端往返。

---

## 5. 表单与校验（服务端权威）

```php
public string $email = '';

protected function rules(): array
{
    return ['email' => 'required|email'];
}

public function save()
{
    $this->validate();
    // 持久化到 Laravel 模型
    User::create($this->only('email'));
    session()->flash('ok', '订阅成功');
    $this->reset('email');
}
```
```html
<form wire:submit.prevent="save">
    <flux:field>
        <flux:label>邮箱</flux:label>
        <flux:input wire:model="email" type="email" />
        <flux:error>{{ $errors->first('email') }}</flux:error>
    </flux:field>
    <flux:button type="submit" variant="primary">提交</flux:button>
</form>
```

---

## 6. 持久化与会话

```php
use Livewire\Attributes\Locked;

#[Locked]               // 防止前端篡改
public int $userId;

// 跨请求持久化（如购物车）
public function mount()
{
    $this->cart = session('cart', []);
}
public function addToCart($id)
{
    $this->cart[] = $id;
    session(['cart' => $this->cart]);
}
```

---

## 7. 性能与最佳实践

- 公共属性**只暴露必要字段**，避免把整个 Eloquent 模型绑到前端（泄露 + 体积）。
- 大列表用 `WithPagination` + `lazy` 分页。
- 用 `wire:model.live.debounce` 抑制高频同步。
- 纯视觉交互交给 Alpine，减少服务端往返。
- 组件拆分粒度适中：一个组件管一块内聚 UI，跨块通信走事件而非共享状态。

---

## 8. 检查清单
- [ ] 服务端状态用 public 属性，纯前端状态用 Alpine `x-data`
- [ ] 搜索/输入用 `.live.debounce`
- [ ] 跨组件用 `dispatch` / `#[On]` / `$dispatch`
- [ ] 表单校验服务端权威（`validate()`）
- [ ] 不泄露整个模型到前端
- [ ] 列表分页，避免整表重渲染
