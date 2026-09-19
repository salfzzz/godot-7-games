# 03. Farming — 农场经营

**状态：** 🚧 进行中 · 初始工程已导入

2D 俯视视角农场游戏，含角色动画、工具切换、自动图块（autotiling）、种植与昼夜循环。

## 文件夹结构

```
03.Farming/
├── README.md          本说明
├── NOTES.md           开发日志（边做边记）
├── project.godot      Godot 项目本体（用 Godot 4 打开这一层）
├── audio/             音效与音乐
├── graphics/          角色 / 植物 / 图块集 / UI 素材
├── scenes/            场景
│   ├── level/game.tscn
│   └── player/player.tscn
├── globals/           （空，后续放全局脚本）
└── shaders/           （空，后续放着色器）
```

## 怎么打开

用 Godot 打开本文件夹里的 `project.godot`。

> 课程录制时用的是 Godot 4.4，我本机是 **4.7.2**。首次打开时 Godot 会把
> `config/features` 从 `"4.4"` 升级到 `"4.7"`，并重写 `.import` 文件，
> 这些改动需要一并提交。

## 当前进度

- [x] 导入课程初始工程（`01.intro`）
- [x] 主场景已配置为 `scenes/level/game.tscn`
- [x] 角色基础移动代码（`player.gd`，四方向 `Input.get_vector`）
- [ ] 角色动画（AnimationPlayer 驱动方向动画）
- [ ] 移动动画切换
- [ ] 枚举（enums）管理工具/种子状态
- [ ] 工具动画（锄头 / 斧头 / 水壶）
- [ ] 自动图块（autotiling）
- [ ] 关卡设计
- [ ] 工具使用逻辑
- [ ] 种植系统
- [ ] 昼夜循环

## 已内置的输入映射

`project.godot` 里已经配好：

| 动作 | 按键 | 用途 |
|---|---|---|
| `left` / `right` / `up` / `down` | A / D / W / S | 四方向移动 |
| `action` | 空格 | 通用交互 |
| `tool_forward` / `tool_backward` | E / Q | 切换工具 |
| `seed_toggle` | C | 切换种子 |
| `plant` | F | 种植 |

## 物理层命名

`project.godot` 里已命名，代码里可直接用：

| 层 | 名称 |
|---|---|
| 1 | `terrain` |
| 2 | `player` |
| 3 | `plants` |
| 4 | `enemies` |

## 显示设置

- 视口 **1920 × 1080**，`stretch/scale = 4.0`
- `default_texture_filter = 0`（**Nearest**）→ 像素画项目，不要随手开线性过滤或 mipmap

## 关于初始素材来源（如实说明）

本项目的初始工程（美术、音效、`project.godot` 配置、基础移动脚本）来自付费课程
《Godot 零基础实战入门：手把手带你完成 7 个小游戏》的 Farming 章节。

**游戏逻辑代码由我自己跟随课程逐步编写**，每次提交都对应我实际写下的进度。
课程素材版权归原作者所有，本仓库仅作个人学习记录用途。

## 开发工作流

在**仓库根目录**运行一键脚本：

```powershell
cd D:\Godot\Godot_source
.\push.ps1 "完成角色移动动画" -Project 03.Farming
```

手动方式：

```bash
git add 03.Farming
git commit -m "feat(03.Farming): 完成角色移动动画"
git push
```

## 学到的 Godot 知识点

<!-- 边做边记，也可以直接写在 NOTES.md 里 -->

## 踩过的坑

<!-- 记录问题和解决方案 -->
