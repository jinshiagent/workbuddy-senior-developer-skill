# 进阶技术范式（Advanced Tech Patterns）

覆盖两类"制造 wow 感"的核心技术：**Three.js 粒子系统** 与 **高性能 CSS 动效**。二者都必须服从性能预算（60fps、首屏 < 1.5s）。

---

## 1. Three.js 粒子系统集成范式

### 1.1 适用场景
- Hero 区粒子背景 / 星空 / 数据流
- 交互式 3D 产品展示
- 平滑视差滚动（相机随滚动位移）

### 1.2 推荐架构
- 使用 **`BufferGeometry` + `Points` + `PointsMaterial`**（数千粒子也不卡），**禁止**为每个粒子创建 `Mesh`。
- 通过 `requestAnimationFrame` 驱动；用 `clock.getDelta()` 做帧率无关动画。
- 设备像素比上限 `renderer.setPixelRatio(Math.min(devicePixelRatio, 2))`，防止 4K 屏过度绘制。
- 视口 `resize` 时更新 `camera.aspect` 与 `renderer.setSize`，并 `throttled`。

### 1.3 最小可用粒子场（核心逻辑，模板见 `assets/hero-threejs.html`）
```js
import * as THREE from 'three';

const scene = new THREE.Scene();
const camera = new THREE.PerspectiveCamera(75, innerWidth / innerHeight, 0.1, 1000);
camera.position.z = 60;

const renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true });
renderer.setSize(innerWidth, innerHeight);
renderer.setPixelRatio(Math.min(devicePixelRatio, 2));
document.getElementById('hero-canvas').appendChild(renderer.domElement);

// 3000 个粒子
const COUNT = 3000;
const positions = new Float32Array(COUNT * 3);
for (let i = 0; i < COUNT * 3; i++) positions[i] = (Math.random() - 0.5) * 200;
const geo = new THREE.BufferGeometry();
geo.setAttribute('position', new THREE.BufferAttribute(positions, 3));

const mat = new THREE.PointsMaterial({
  size: 0.7, color: 0x34d399, transparent: true, opacity: 0.9,
  blending: THREE.AdditiveBlending, depthWrite: false
});
const points = new THREE.Points(geo, mat);
scene.add(points);

const clock = new THREE.Clock();
function animate() {
  requestAnimationFrame(animate);
  const t = clock.getElapsedTime();
  points.rotation.y = t * 0.05;
  points.rotation.x = Math.sin(t * 0.1) * 0.1;
  renderer.render(scene, camera);
}
animate();
```

### 1.4 性能与降级
- 粒子数随屏幕宽度自适应（移动端 ≤ 1200，桌面 ≤ 4000）。
- 检测 `prefers-reduced-motion`：关闭旋转/漂移，渲染一帧静态。
- 检测 WebGL 不可用：用 CSS 渐变背景兜底，不阻塞首屏。
- 用 `IntersectionObserver` 在 Hero 离开视口时 `cancelAnimationFrame` 暂停渲染。

---

## 2. 高级 CSS 动效性能优化（硬件加速 / 60fps 预算）

### 2.1 黄金法则：只动 `transform` 与 `opacity`
浏览器复合层（compositor）只便宜地处理这两类属性；其余属性会触发 **重排（reflow）或重绘（repaint）**，导致掉帧。

| ✅ GPU 友好 | ❌ 触发重排/重绘 |
|---|---|
| `transform: translate/scale/rotate` | `top/left/right/bottom` 动画 |
| `opacity` 渐变 | `width/height/padding/margin` 动画 |
| `transform: translateZ(0)` 提升图层 | `box-shadow` 大范围动画（重绘） |
| `filter` 局部（谨慎） | `background-position` 大图动画 |

### 2.2 图层提升（will-change / translateZ）
```css
.gpu { transform: translateZ(0); will-change: transform, opacity; }
```
- `will-change` **只用于确实持续动画的元素**，动画结束后移除，避免常驻图层撑爆内存。
- 不要用 `will-change` 给几十个元素"预防式"加，那是反模式。

### 2.3 60fps 预算拆解
- 单帧预算 ≈ **16.7ms**（1000/60）。其中 JS + 样式 + 布局 + 绘制 + 合成必须全部吃完。
- 长列表滚动动画：用 `content-visibility: auto` 跳过屏外渲染。
- 滚动驱动动画：用 `IntersectionObserver` 触发 class，而非滚动事件内同步计算。

### 2.4 关键帧曲线（premium 减速）
```css
:root { --ease-premium: cubic-bezier(0.16, 1, 0.3, 1); }
.card { transition: transform .4s var(--ease-premium), opacity .4s var(--ease-premium); }
.card:hover { transform: translateY(-6px) scale(1.02); }
```
- 进入动画用 `@keyframes` + `animation`，离开用 `transition` 反向，保证可逆。

### 2.5 入场动画（stagger）
```css
@keyframes riseIn { from { opacity:0; transform: translateY(16px);} to {opacity:1; transform:none;} }
.reveal { animation: riseIn .6s var(--ease-premium) both; }
.reveal:nth-child(2){ animation-delay:.08s; }
.reveal:nth-child(3){ animation-delay:.16s; }
```

### 2.6 视差（parallax）
```js
const layer = document.querySelector('.parallax');
addEventListener('scroll', () => {
  requestAnimationFrame(() => {
    layer.style.transform = `translateY(${scrollY * 0.2}px)`;
  });
}, { passive: true });
```
- 用 `passive: true` 滚动监听 + `rAF` 节流；只改 `transform`。

---

## 3. 资源加载性能

- **关键 CSS 内联**到 `<head>`，避免渲染阻塞。
- 非关键 JS（Three.js 等）用 `type="module"` + `defer`，或用动态 `import()` 懒加载。
- 图片 `loading="lazy"` + `decoding="async"`；首屏图用 `fetchpriority="high"`。
- 字体 `font-display: swap`，必要时 `preload` 关键字体。

---

## 4. 检查清单
- [ ] 粒子用 BufferGeometry+Points，非逐 Mesh
- [ ] pixelRatio 封顶 2，resize 节流
- [ ] 离屏暂停渲染（IntersectionObserver）
- [ ] 动效仅 transform/opacity，曲线为 premium 减速
- [ ] will-change 不滥用
- [ ] reduced-motion 已降级
- [ ] 关键 CSS 内联，非关键资源懒加载
