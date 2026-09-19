# 开发日志 — 03. Farming

> 记录 03.Farming 的开发过程、踩过的坑与解决方案。

**目录**

- [2026-09-19](#2026-09-19)
  - [导入初始工程](#导入初始工程)
- [待办](#待办)
- [问题记录](#问题记录)

---

## 2026-09-19

### 导入初始工程

- 从课程 `3.Farming/01.intro` 导入初始工程到 `03.Farming/`
  - 注意：这个项目的起始文件夹叫 `01.intro`，前两个游戏叫 `00.初始项目`
- 工程已自带主场景配置：`run/main_scene` 指向 `scenes/level/game.tscn`
  - 对比 `02.Metroid` 当时没有配 `main_scene`，F5 会弹选择框，这次省事
- 已自带的脚本：`scenes/player/player.gd`（四方向移动）
- `globals/` 和 `shaders/` 是空目录，课程留着后面填内容

**工程配置要点：**

| 项 | 值 | 说明 |
|---|---|---|
| 分辨率 | 1920 × 1080 | 配合 `stretch/scale = 4.0` |
| 纹理过滤 | Nearest（0） | 像素画项目 |
| 物理层 | terrain / player / plants / enemies | 已命名 |

**输入映射（已内置）：**

| 动作 | 按键 |
|---|---|
| `left` / `right` / `up` / `down` | A / D / W / S |
| `action` | 空格 |
| `tool_forward` / `tool_backward` | E / Q |
| `seed_toggle` | C |
| `plant` | F |

**已有的 `player.gd`：**

```gdscript
extends CharacterBody2D

var direction: Vector2
var speed := 300

func _physics_process(delta: float) -> void:
	get_input()
	velocity = direction * speed
	move_and_slide()

func get_input():
	direction = Input.get_vector("left", "right", "up", "down")
	print(direction)
```

- 用的是 `Input.get_vector()` 读取**两个坐标轴**（对比 `01.Frogger` 的 `get_axis()` 是单轴）
- 注意：`get_input()` 里有一句 `print(direction)`，每帧都打印，调试完应该删掉

### 待办

- [ ] 角色动画（AnimationPlayer）
- [ ] 移动动画切换
- [ ] 枚举管理工具 / 种子状态
- [ ] 工具动画（锄头 / 斧头 / 水壶）
- [ ] 自动图块（autotiling）
- [ ] 关卡设计
- [ ] 工具使用逻辑
- [ ] 种植系统
- [ ] 昼夜循环

### 待确认的问题

<!-- 遇到问题记在这里，解决了就写答案 -->

---

## 问题记录

### 与前两个项目的对照

| | 01.Frogger | 02.Metroid | 03.Farming |
|---|---|---|---|
| 起始文件夹名 | `finished-frogger`（成品） | `00.初始项目` | `01.intro` |
| 是否自带脚本 | 全部成品 | 无 | `player.gd` |
| 是否配 `main_scene` | 是 | 否（要自己配） | 是 |
| 视角 | 2D 俯视 | 2D 横版 | 2D 俯视 |
| 分辨率 | 1280×720 | 1280×720 | 1920×1080（scale 4.0） |
| 输入 | `get_axis` 单轴 | `get_axis` 单轴 | `get_vector` 双轴 |

<!-- 后续继续补充 -->
