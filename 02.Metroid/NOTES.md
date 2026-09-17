# 开发日志 — 02. Metroid

## 2026-09-16

- 用 Godot 打开项目，确认素材齐全（字符 / 火焰 / 光照 / TileSet / UI）
- 确认输入映射已内置：left(A) / right(D) / jump(空格) / shoot(鼠标左键)
- 确认本机 Godot 版本为 **4.7.2.stable**，课程录制用的是 4.4，菜单可能略有差异
- 确认 `.md` 文件在 Godot 脚本编辑器里可以当纯文本打开编辑（无 Markdown 渲染）

## 2026-09-17

- 新建 Level 场景，文件存放在新建的 `scenes/levels/` 文件夹中
- 在 Level 场景里新建了 StaticBody2D 和 CollisionShape2D
- 新建玩家场景，并且挂载到了主场景中，编写基础移动代码脚本
- 处理左右移动的代码，使用get_input函数，里面调用 ** get_axis() **来读取单个坐标轴的键盘输入，类似第一个游戏的get_vector()读取两个坐标轴输入
- 继续处理跳跃操作，逻辑一致，用 ** Input.is_action_just_pressed() ** 来检测玩家是否按下了跳跃键，一旦检测到，则velocity.y需要改变为负值（因为负y轴在godot显示为向上跳跃）
- 还要新建跳跃高度的变量 jump_strength，用于控制角色跳跃能达到的高度
- 处理跳跃后的下落效果，创建allpy_gravity()函数，只需要让其执行自增操作，在画面中就能达到自然下落效果
- 顺便给玩家节点挂载相机

- 实现开火键的输入读取，同时还要支持开火间隔：同样Input.is_action_just_pressed()检测，并且 ** 新建timer计时器 ** 来控制射击间隔(要设计为one shot 单次触发)
- 当玩家按下按键且timer计时器已经等于0时，说明冷却时间已过，可以进行下一次射击 ，此时再次启动timer计时器
- 开始实现发射子弹的逻辑，首先要给主场景挂载脚本，让子弹能出现在主场景中
- #signal shoot(pos :Vector2 , dir : Vector2 ) 新建发射信号，内部参数是子弹出发时的位置信息和方向向量
 处理 自带信号中的方向向量参数（既射出的子弹的方向） ，需要使用到自带的函数#get_local_mouse_position()，该函数能获取本地鼠标点击的坐标（以自身原点为参照），


- 开始给子弹添加贴图，首先新建bullet的area2D场景，节点下再新建sprite2d节点和collisionshape2d用来展示贴图和碰撞模型
为了让主场景里看到子弹的贴图，在Level主场景中新建node2d子节点bullets统一存放所有后续生成的子弹，同时在level的脚本中，定义变量  ** bullet——scene来存放preload（XXX/bullet.tscn）** 预加载子弹场景
- 一旦玩家触发了子弹发射的信号，则生成一个子弹的实例，** bullet_scene变量调用instantiate()函数 ** 
- 之后再用 ** $Bullets.add_child(bullet) ** 将该实例作为子节点添加到主场景下的bullet节点下

- 接下来修改 子弹初始生成的位置和方向， 同样需要在level场景，接收到信号后，调用bullet脚本中自定义的setup函数，由bullet脚本来执行
setup函数编写在bullet脚本中，里面用于处理子弹生成的位置 和方向向量，同时还要在_physics_process新增子弹飞行的逻辑

- 准备进行角色的动画创建， 这次使用AnimationPlayer节点，首先将素材导入sprite2d，在检查器里面的animation动画中切割帧，将其分成一帧一帧的动画，
- 在animationplayer中新建动画，对sprite2d里的frame构建动画,分别对奔跑和停止两种行为创建动画
 创建完成后要在player的脚本中实现两种动画的切换
- 设置animation函数，对$AnimationPlayer 的实际播放动画（current_animation 进行检查，如果x轴方向向量不ie，设置为run奔跑动画，反之则设置为idle待机等待状态
 同时在其中添加向左移动时更改贴图朝向的逻辑，通过 $Legs.flip_h = direction_x < 0 实现
- 实现跳跃逻辑，用character自带的on_the_floor函数，检查角色是否在地面上，在地面上则播放待机或奔跑，不在则播放跳跃
- 接下来进行躯干的动画处理，由于躯干的朝向取决于角色射击的方向，所以不能用animationplayer处理
处理方法如下 
’‘
	同时构建字典对应八个射击方向
	const gun_directions = {        #用于控制枪械朝向的字典
	Vector2i(1,0) : 0 ,	Vector2i(1,1) : 1 ,	Vector2i(0,1) : 2 ,	Vector2i(-1,1) : 3 ,	Vector2i(-1,0) : 4 ,
		Vector2i(-1,-1) : 5 ,	Vector2i(0,-1) : 6 ,	Vector2i(1,-1) : 7 
}
	var raw_dir = get_local_mouse_position().normalized()   //获取鼠标指向的方向向量作为初始的方向向量
	var adjust_dir  = Vector2(round(raw_dir.x), round(raw_dir.y))    //再用round（）函数对初始的数值进行四舍五入的处理，这样只会输出三个所需的值 （1，0，1）
	最后调用 Torso.frame  = gun_direction[adjust_dir] 把转换后的方向生成的vector2值进行字典匹配，更改对应的躯干朝向
’‘
---------------
- 后续进行准星的开发调试，首先同样在player中创建spire2d节点，然后新建animationplayer2d节点，里面主要实现的是准星缩放的动画效果，
在把动画效果导入后，需要在get_input函数下实现逻辑：当点击射击键时，不仅需要发射子弹，还要显示准星的缩放
上述实现过于繁杂，可以使用更简单的实现方式，我们可以采用tween差值动画方法：

首先需要定义新tween实例，再通过get_tree获取场景树，进而create_tween将新实例赋值给变量
紧接着用tween_property(节点类型,需要修改的属性，用于过度的目标数值，动画持续的时长)赋值给新实例
后续根据该方法实现了子弹的变大功能
-----------

-准备实现瓦片地图 ，首先新建tileMapLayer节点，接着在检查器页面选择新建tileset，在下部面的tileset将自身的瓦片集导入
	后续要新建多个瓦片集来摆放背景，物体，光源等贴图，同时为了让地形具有碰撞体，需要在下方tileset的选项中，选择“绘制”按钮，再选择回值物理层属性
	


### 待办

- [√] 搭建玩家场景（`scenes/player.tscn`）
- [√] 写 `player.gd`，接上 `left` / `right` / `jump` 输入
- [ ] 接入 `AnimationPlayer` 做待机 / 跑动 / 跳跃动画

--------------
### 待确认的问题

<!-- 遇到问题记在这里，解决了就写答案 -->
## 9.17 开发问题记录
- 一开始忘记1了基础行走代码，后续查看第一个游戏，发现要使用direction*speed = velocity ，和move_and_slide 
-  由于是2d平面游戏，所以主要要实现左右移动和跳跃，先重构左右移动代码
- 跳跃后停在半空的问题  ——> 要新建重力函数来单独处理
- 同时修改多行代码，按住alt键，再鼠标点击对应位置
- @export 可以将变量参数 显式放置在检查器位置，便于运行过程中修改
- 目前在运行时，玩家节点会疯狂抖动，解决办法是#在项目选项栏中选择项目设置，下拉找到物理，在里面的通用中打开高级设置，并打开物理插值
- 实现子弹的射击逻辑时，由于子弹是由角色发射的，所以要在玩家节点新建信号，用于控制子弹的发射，##要注意新建信号后，需要在满足条件时进行信号的传输
- get_local_mouse_position() 会造成一个问题，得到的向量长度不一致，导致子弹飞行的距离有很大差异，此时需要调用#归一化方法normalized()，将向量长度归一化为1
- 我进行子弹生成的开发时，发现当前子弹会始终出现在角色的左上角 ，原因询问ai后发现是 ** pos 的坐标系（Entities）和子弹的父节点坐标系（Bullets）不是同一个，你直接把数值搬过去了 **
 暂时的修复方法是 在level的2D场景下， ** 把entities节点和bullets节点都统一放在0，0原点处 ** 

- 此时运行时我发现子弹生成时看起来像从远方飞过来的，关掉物理插值后该问题解决，但是角色会产生剧烈抖动，待解决
- 完成跳跃动画逻辑后，发现小ug 目前在向左跳跃的过程中。若在跳跃过程中松开a按键，会导致动画强制转向成右侧跳跃的样式
- *** 修改方法 ：  新建一个控制朝向的变量，在有输入的时候监测是否需要水平轴反转，如下列逻辑：

‘’
func animation():
	if direction_x != 0:  //#如果存在左右方向非0
		facing = sign(direction_x)   //facing是控制朝向的变量
	$Legs.flip_h = facing < 0  //若朝向向量为负（既为左方向），此时facing为1，判断条件会返回true 则设置水平轴翻转
	...
’‘ ***

-
