# 开发日志 — 02. Metroid

## 2026-09-16

- 用 Godot 打开项目，确认素材齐全（字符 / 火焰 / 光照 / TileSet / UI）
- 确认输入映射已内置：left(A) / right(D) / jump(空格) / shoot(鼠标左键)
- 确认本机 Godot 版本为 **4.7.2.stable**，课程录制用的是 4.4，菜单可能略有差异
- 确认 `.md` 文件在 Godot 脚本编辑器里可以当纯文本打开编辑（无 Markdown 渲染）
- 下一步：搭建玩家场景

### 待办

- [ ] 搭建玩家场景（`scenes/player.tscn`）
- [ ] 写 `player.gd`，接上 `left` / `right` / `jump` 输入
- [ ] 接入 `AnimationPlayer` 做待机 / 跑动 / 跳跃动画

### 待确认的问题

<!-- 遇到问题记在这里，解决了就写答案 -->
