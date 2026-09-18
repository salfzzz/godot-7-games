# 02. Metroid — 横版闯关

**状态：** 🚧 进行中 · 环境已就绪，准备搭建玩家场景

2D 横版平台射击，含子弹、动画、TileMap、光照与 Shader。

## 文件夹结构

```
02.Metroid/
├── README.md          本说明
├── NOTES.md           开发日志（边做边记）
├── project.godot      Godot 项目本体（用 Godot 4.7 打开这一层）
├── audio/             音效素材
└── graphics/          美术素材
```

## 怎么打开

用 Godot 打开本文件夹里的 `project.godot`。

> 课程录制时用的是 Godot 4.4，我本机是 **4.7.2**。4.x 向下兼容，
> 但个别菜单位置和课程画面可能略有出入。

## 当前进度

- [x] 导入课程初始工程（素材 + `project.godot`）
- [x] 确认素材齐全、输入映射可用
- [x] 搭建玩家场景
- [x] 角色基础移动
- [x] 子弹与射击
- [x] AnimationPlayer 动画
- [x] Tween 补间
- [x] TileMap 关卡
- [x] 无人机敌人
- [x] 分组（groups）
- [x] 2D 光照
- [x] Shader 效果
- [x] 标题界面与游戏结束流程

**状态：已完成**，Windows 可执行版见 [Releases](https://github.com/salfzzz/godot-7-games/releases/tag/v1.0-metroid)。

### 玩法

| 操作 | 按键 |
|---|---|
| 开始 / 重新开始 | 空格 |
| 左右移动 | A / D |
| 跳跃 | 空格 |
| 射击 | 鼠标左键 |

无人机有 3 点生命值，击中后会被摧毁；被无人机撞到则游戏结束。

进度详情见 [NOTES.md](NOTES.md)。

## 已内置的输入映射

`project.godot` 里已经配好，代码里可直接用：

| 动作 | 按键 |
|---|---|
| `left` | A |
| `right` | D |
| `jump` | 空格 |
| `shoot` | 鼠标左键 |

## 关于初始素材来源（如实说明）

本项目的初始工程（美术、音效、`project.godot` 配置）来自付费课程
《Godot 零基础实战入门：手把手带你完成 7 个小游戏》的 Metroid 章节。

**游戏逻辑代码由我自己跟随课程逐步编写**，每次提交都对应我实际写下的进度。
课程素材版权归原作者所有，本仓库仅作个人学习记录用途。

## 开发工作流

在**仓库根目录**（不是本文件夹）运行一键脚本：

```powershell
cd D:\Godot\Godot_source
.\push.ps1 "完成玩家场景" -Project 02.Metroid
```

脚本会自动补上 `feat(02.metroid):` 前缀、检查课程资料是否误入暂存区、然后推送。

手动方式：

```bash
git add 02.Metroid
git commit -m "feat(metroid): 完成角色基础移动"
git push
```

## 学到的 Godot 知识点

<!-- 边做边记，也可以直接写在 NOTES.md 里 -->

- 场景（Scene）与节点（Node）树的组织方式
- `project.godot` 里的输入映射（Input Map）如何对应代码中的 `Input.is_action_pressed()`

## 踩过的坑

<!-- 记录问题和解决方案 -->
