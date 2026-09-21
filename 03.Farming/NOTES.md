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

### 9-20  
- 前置知识学习： 1.  “类星露谷游戏”需要处理大量的角色动画素材，如移动，挥砍，挖掘，开垦等等，需要实现的动画效果很多，
- 故需要借助animationTree来实现，初始文件中已经配置好了所有的基础动画（通过新建动画并且选中对应播放帧）
			   2. 为了再游戏中实现开垦，挖掘的功能，要学习使用自动铺设瓦片功能，使得玩家能在游戏中改变地形
			   3.  为了实现人物工作实现的逻辑（检测玩家当前手持哪种工具），需要使用枚举enum类型

- 先实现人物的基础移动，首先在输入映射中将对应按键绑定对应的行为，接着挂载脚本，读取输入,input,get_vector来识别对应方向向量
-  此时移动时动作不明显，基本看不到移动
- 开始实现基础的待机和行走动画，为了后续动画的无缝衔接，这次动画实现统一使用animationtree实现（重点！！！）



- 配置animationtree ：  1.基础作用 ： 从animationplayer中调取不同的动画，有3种实现方式 ：   一.blendtree混合树（对不同动画间进行融合过度)  二.statemachine状态机 (切换不同动画状态) 三. blendspace混合空间 (根据标记点位置，切换对应动画)
 三种实现方式可以组合使用 （例如这一次就是在blendtree中嵌套statemachine使用)
 - 在animationtree的工作区内右键空白区域即可新建新的子节点，	同样，在blendtree中能够新建statemachine，在点击	“打开编辑器：即可进入statemachine的编辑区域
 - 	 1. 在statemachine编辑区界面，我们再次右键空白区域，新建blendspace2d，用来存放所有的idle，mov的动画，后续还会添加更多
	 2. 在blendspace的编辑页面，分成了坐标系，可以设置坐标点，系统就可以根据对应的坐标点位置来播放对应选中的动画。我们先在四个坐标轴方向创建坐标点，分别对应四个方向的待机动画，再在statemachine编辑页面将Start连接到对应的”idle"blendspace上
     3.  接着准备开始编写代码逻辑，新建animation函数，当存在方向向量时，需要设置animationtree -> move statemachine -> idle ,修改其对应的position
	  ps:需要注意的是，在blendspace编辑器中的y轴和Godot里默认的相反，既blendspace中向上递增，向下递减
	 4. 	如果存在方向向量，则将对应的输入direction数值传给blendspace中，  （一定要注意纵向的up和down逻辑和godot内置不同）
	 '' $AnimationTree.set("parameters/MoveStateMachine/idle/blend_position",direction) ''
	 bus修复 ：由于blendspace目前只绑定了4个坐标轴上的点位，导致如果出现传入的方向向量没有落到对应区域，则会造成随机播放动画的效果，所以还要补充动画逻辑，覆盖blendspace中的整个单位区域
	 优化建议 ：最好把方向向量处理成离散规整数值， 对传入的方向向量进行取整处理,这样我们最后传入idle ,修改其对应的position时，只会传入0，1两种值
	
	
	-现在开始实现行走动画以及待机和行走动画之间的切换
	 1.基础的行走动画流程与idle待机动画一致，只需在state Machine中新建blendspace，再把对应再把对应坐标应该播放的动画一一对应，这样就能实现基础的move动画逻辑，
	 2.而为了实现move动画和idle动画之间的切换，需要再state Machine中将idle和move动画建立节点连接，同时关闭对应的自动触发，改为只有持续按下移动按键，才会从idle状态切换到move状态
	 3. 后续首先要用 @onready var move_state_Machine : AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/MoveStateMachine/playback")
	    在程序刚刚启动的时候获取animationplayer播放器，用于控制整个状态机,后续在animation函数中，如果检测到移动方向，则跳转到move动画
	  反之则执行待机动画
	bugs修复 ：当前移动后停止，待机动画固定为向下待机，解决方法是在存在方向向量进入if语句时同步更新idle待机动画里面的position数值，确保停止后也能播放对应的动画




- 接下来开始准备各个工具以及其相关的逻辑间的切换 主要要用到“Enum”枚举功能，其能够提供固定不变，清晰直观的状态标识  ，本质时存放整数
首先新建枚举类型，内容包括锄头，斧头和水壶，其会被自动对应为0，1，2 ，再新建变量用来记录当前使用的时第几个物品，如果is_action_just_pressed触发，则检查当前的工具，进行匹配
ps：为了处理记录的数值可能无限增大or缩小，使用正向取模函数“posmod”要求取模后只存在0，1，2三个数(posmod保证结果永远是非负整数)  ,最后再函数后面加上as Tools，保证数据类型仍是Tools不变
ps: 为了使函数更加简洁优雅，新增变量tool——direction用来控制是正向选择还是负向选择，
''
	if Input.is_action_just_pressed("tool_forward") or Input.is_action_just_pressed("tool_backward") :
		var tool_direction = Input.get_axis("tool_backward","tool_forward") as int
		current_tool = posmod(current_tool + tool_direction ,Tools.size()) as Tools
''
核心要点 : 判断代码是否按下tool_forward或者tool_backward,只要触发任意一个按键，对tool_direction	进行赋值，并且进行对应的加或减


## 9-21

 - 准备开始实现切换工具的动画	
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
