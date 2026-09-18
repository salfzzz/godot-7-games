# 开发日志 — 02. Metroid

> 记录 02.Metroid 的开发过程、踩过的坑与解决方案。

目录

- [2026-09-16](#2026-09-16)
- [2026-09-17](#2026-09-17)
  - [基础场景与移动](#基础场景与移动)
  - [射击与子弹](#射击与子弹)
  - [角色动画](#角色动画)
  - [准星与 Tween](#准星与-tween)
  - [瓦片地图](#瓦片地图)
- [待办](#待办)
- [待确认的问题](#待确认的问题)

---

## 2026-09-16

- 用 Godot 打开项目，确认素材齐全（字符 / 火焰 / 光照 / TileSet / UI）
- 确认输入映射已内置：left(A) / right(D) / jump(空格) / shoot(鼠标左键)
- 确认本机 Godot 版本为 4.7.2.stable，课程录制用的是 4.4，菜单可能略有差异
- 确认 `.md` 文件在 Godot 脚本编辑器里可以当纯文本打开编辑（无 Markdown 渲染）

---

## 2026-09-17

### 基础场景与移动

- 新建 Level 场景，文件存放在新建的 `scenes/levels/` 文件夹中
- 在 Level 场景里新建了 StaticBody2D 和 CollisionShape2D
- 新建玩家场景，并且挂载到了主场景中，编写基础移动代码脚本
- 处理左右移动的代码，使用 get_input 函数，里面调用 `get_axis()` 来读取单个坐标轴的键盘输入，类似第一个游戏的 get_vector() 读取两个坐标轴输入
- 继续处理跳跃操作，逻辑一致，用 `Input.is_action_just_pressed()` 来检测玩家是否按下了跳跃键，一旦检测到，则 velocity.y 需要改变为负值（因为负 y 轴在 godot 显示为向上跳跃）
- 还要新建跳跃高度的变量 jump_strength，用于控制角色跳跃能达到的高度
- 处理跳跃后的下落效果，创建 allpy_gravity() 函数，只需要让其执行自增操作，在画面中就能达到自然下落效果
- 顺便给玩家节点挂载相机

### 射击与子弹

- 实现开火键的输入读取，同时还要支持开火间隔：同样 `Input.is_action_just_pressed()` 检测，并且新建 timer 计时器来控制射击间隔（要设计为 one shot 单次触发）
- 当玩家按下按键且 timer 计时器已经等于 0 时，说明冷却时间已过，可以进行下一次射击，此时再次启动 timer 计时器
- 开始实现发射子弹的逻辑，首先要给主场景挂载脚本，让子弹能出现在主场景中
- `#signal shoot(pos :Vector2 , dir : Vector2 )` 新建发射信号，内部参数是子弹出发时的位置信息和方向向量
- 处理自带信号中的方向向量参数（既射出的子弹的方向），需要使用到自带的函数 `#get_local_mouse_position()`，该函数能获取本地鼠标点击的坐标（以自身原点为参照）
- 开始给子弹添加贴图，首先新建 bullet 的 area2D 场景，节点下再新建 sprite2d 节点和 collisionshape2d 用来展示贴图和碰撞模型
- 为了让主场景里看到子弹的贴图，在 Level 主场景中新建 node2d 子节点 bullets 统一存放所有后续生成的子弹，同时在 level 的脚本中，定义变量 `bullet_scene` 来存放 `preload(XXX/bullet.tscn)` 预加载子弹场景
- 一旦玩家触发了子弹发射的信号，则生成一个子弹的实例，`bullet_scene` 变量调用 `instantiate()` 函数
- 之后再用 `$Bullets.add_child(bullet)` 将该实例作为子节点添加到主场景下的 bullet 节点下
- 接下来修改子弹初始生成的位置和方向，同样需要在 level 场景，接收到信号后，调用 bullet 脚本中自定义的 setup 函数，由 bullet 脚本来执行
- setup 函数编写在 bullet 脚本中，里面用于处理子弹生成的位置和方向向量，同时还要在 `_physics_process` 新增子弹飞行的逻辑

### 角色动画

- 准备进行角色的动画创建，这次使用 AnimationPlayer 节点，首先将素材导入 sprite2d，在检查器里面的 animation 动画中切割帧，将其分成一帧一帧的动画
- 在 animationplayer 中新建动画，对 sprite2d 里的 frame 构建动画，分别对奔跑和停止两种行为创建动画
- 创建完成后要在 player 的脚本中实现两种动画的切换
- 设置 animation 函数，对 $AnimationPlayer 的实际播放动画（current_animation 进行检查，如果 x 轴方向向量不 ie，设置为 run 奔跑动画，反之则设置为 idle 待机等待状态
- 同时在其中添加向左移动时更改贴图朝向的逻辑，通过 `$Legs.flip_h = direction_x < 0` 实现
- 实现跳跃逻辑，用 character 自带的 on_the_floor 函数，检查角色是否在地面上，在地面上则播放待机或奔跑，不在则播放跳跃
- 接下来进行躯干的动画处理，由于躯干的朝向取决于角色射击的方向，所以不能用 animationplayer 处理

处理方法如下：

```gdscript
同时构建字典对应八个射击方向
const gun_directions = {        #用于控制枪械朝向的字典
Vector2i(1,0) : 0 ,	Vector2i(1,1) : 1 ,	Vector2i(0,1) : 2 ,	Vector2i(-1,1) : 3 ,	Vector2i(-1,0) : 4 ,
	Vector2i(-1,-1) : 5 ,	Vector2i(0,-1) : 6 ,	Vector2i(1,-1) : 7
}
var raw_dir = get_local_mouse_position().normalized()   //获取鼠标指向的方向向量作为初始的方向向量
var adjust_dir  = Vector2(round(raw_dir.x), round(raw_dir.y))    //再用round（）函数对初始的数值进行四舍五入的处理，这样只会输出三个所需的值 （1，0，1）
最后调用 Torso.frame  = gun_direction[adjust_dir] 把转换后的方向生成的vector2值进行字典匹配，更改对应的躯干朝向
```

### 准星与 Tween

- 后续进行准星的开发调试，首先同样在 player 中创建 spire2d 节点，然后新建 animationplayer2d 节点，里面主要实现的是准星缩放的动画效果
- 在把动画效果导入后，需要在 get_input 函数下实现逻辑：当点击射击键时，不仅需要发射子弹，还要显示准星的缩放
- 上述实现过于繁杂，可以使用更简单的实现方式，我们可以采用 tween 差值动画方法：
  - 首先需要定义新 tween 实例，再通过 get_tree 获取场景树，进而 create_tween 将新实例赋值给变量
  - 紧接着用 tween_property(节点类型, 需要修改的属性，用于过度的目标数值，动画持续的时长) 赋值给新实例
  - 后续根据该方法实现了子弹的变大功能

### 瓦片地图

- 准备实现瓦片地图，首先新建 tileMapLayer 节点，接着在检查器页面选择新建 tileset，在下部面的 tileset 将自身的瓦片集导入
- 后续要新建多个瓦片集来摆放背景，物体，光源等贴图，同时为了让地形具有碰撞体，需要在下方 tileset 的选项中，选择"绘制"按钮，再选择回值物理层属性

-

## 2026-09-18

### 无人机敌人实现
- 1.首先新建characterbody2d节点用于创建无人机，后续给其添加animationedsprite2d节点，播放建议的帧动画
  2.为了实现无人机检测攻击行为，需要新建area2d节点，并设置 coll检测范围，逻辑是：一旦角色进入到了无人机的检测范围，就会触发无人机的攻击，所以需要调用信号来处理
  3.在area2d信号中选择body_entered信号，同时还要记得更改无人机（drone）和area2d的碰撞分层，area2d不被碰撞检测且只检测角色
  4.接着在实现无人机的运行逻辑：只有在检测到玩家之后才会触发移动，所以要新建全局变量来获取当前玩家的坐标位置，如果角色进入到了检测范围，则用角色当前的位置坐标减去无人机的坐标，可以得到一组数值，拿这一组数值
  5. 就可以当作方向向量，告知无人机向哪个方向移动   (同时还要记得调用normalized归一化，统一计算velocity)
  6. 同样，还要实现角色离开检测范围后，无人机停止的逻辑，实现起来同样需要area2d的信号，使用的是body_exited,一旦接受到该讯号，则把全局变量player设置为null，这样就不会触发移动了
  7. 这里再实现一个额外的功能：角色离开后不会立刻停止移动，而是在离开检测区域两秒后，在停止
  解决方案：使用计时器节点，调用计时器的timeout信号，同时还要设置新的变量is_active来决定是否停止移动
	进入时停止计时器，一旦角色一离开检测区域，计时器开始运行，一旦运行2秒结束后，is_active设置为false，is_active为false时，velocity设为zero
  - 继续实现无人机碰撞到玩家实体执行爆炸的逻辑：
  1. 首先新建spire2d节点存储爆炸动画的帧，接着这次使用animationplayer节点，将爆炸动画的帧导入，设置动画，接着给无人机新增一个area2d用于检测触发爆炸的区域，子节点选用colshape2d
  2. 同样设置好对应的col的layer和mask（只识别角色，不识别其他）  ，调用其的body_entered（），一旦角色进入爆炸区域，则播放爆炸动画， （注意要把原来的无人机正常状态的实体hide掉）
使用await函数等待动画播放完毕之后，使用queue_free删除爆炸的无人机
  3. 还要实现子弹击中无人机，扣除血量并且销毁子弹的逻辑：在bullet脚本下的area2d种，调用bodyentered信号，一旦有实体（无人机或地形）进入，则销毁子弹实体
	如果是击中无人机（用if"hit" in body 语句判断该实体是否具有hit函数）则触发hit函数
	同时在无人机脚本中新建hit函数，设置血量为3，每触发1次函数，health值就-1,一旦值为0，则触发与爆炸销毁相同的逻辑（同上）
 
 - 准备实现连锁爆炸功能（一个无人机的爆炸会触发相邻无人机的爆炸）
   1.首先要学习使用分组的方法，选中根节点（这里使用drone）在检查器的右边新建无人机分组   （get_tree().get_nodes_in_group("无人机") 可以查看场景树下"无人机"分组的全部内容
   2. 了解完分组后，在无人机爆炸函数内准备实现"连锁爆炸"的功能  ,在爆炸函数内使用for drone in get_tree().get_nodes_in_group("无人机"):，由于其返回值是数组，可以进行for循环遍历
		在里面加上if逻辑：读取分组中无人机的间距 (调用distance_to来比较)，间距小于一定的数值后，自动触发爆炸，未满足条件则不会同步爆炸
   3.同时为了优化连锁爆炸的动画，需要在爆炸动画的animation player中 添加调用方法轨道，对指定的时间位置，触发插入的函数

 - 处理灯光逻辑，需要用到Pointlight2d和directionallight2D，各个参数可通过右侧检查器调节，这里要把Pointlight2d绑定到角色根节点上，让角色常亮,同时导入资源文件夹中的光源，让指示牌亮起来
	 后续还可以实现闪烁的效果，再level脚本中实现，同样使用tween帧间动画实现：
	var light_tween = create_tween()
	 light_tween.tween_property($GreenLight5,"energy",1.1,2) 来修改光源强度为1.1，持续2秒
	 light_tween.tween_property($GreenLight5,"energy",0.9,2) 来修改光源强度为0.9，持续2秒
	在再上面添加light_tween.set_loops() 设置无限循环  就可以实现指示牌灯光变化
	
	实现无人机灯光变化：要将pointlight挂载到无人机节点下，再调整大小和色彩，最后把pointlight加入到animationplayer中
	根据energy的值来实现灯光的闪烁效果   
## 待办

- [x] 搭建玩家场景（`scenes/player.tscn`）
- [x] 写 `player.gd`，接上 `left` / `right` / `jump` 输入
- [ ] 接入 `AnimationPlayer` 做待机 / 跑动 / 跳跃动画

---

## 待确认的问题

<!-- 遇到问题记在这里，解决了就写答案 -->

### 9.17 开发问题记录

#### 基础移动

- 一开始忘记了基础行走代码，后续查看第一个游戏，发现要使用 direction*speed = velocity，和 move_and_slide
- 由于是 2d 平面游戏，所以主要要实现左右移动和跳跃，先重构左右移动代码
- 跳跃后停在半空的问题 ——> 要新建重力函数来单独处理

#### 编辑器技巧

- 同时修改多行代码：按住 alt 键，再鼠标点击对应位置
- `@export` 可以将变量参数显式放置在检查器位置，便于运行过程中修改
- 目前在运行时，玩家节点会疯狂抖动，解决办法是：在项目选项栏中选择项目设置，下拉找到物理，在里面的通用中打开高级设置，并打开物理插值

#### 射击与子弹

- 实现子弹的射击逻辑时，由于子弹是由角色发射的，所以要在玩家节点新建信号，用于控制子弹的发射，要注意新建信号后，需要在满足条件时进行信号的传输
- `get_local_mouse_position()` 会造成一个问题，得到的向量长度不一致，导致子弹飞行的距离有很大差异，此时需要调用 `#归一化方法normalized()`，将向量长度归一化为 1
- 我进行子弹生成的开发时，发现当前子弹会始终出现在角色的左上角，原因询问 ai 后发现是 pos 的坐标系（Entities）和子弹的父节点坐标系（Bullets）不是同一个，你直接把数值搬过去了
  - 暂时的修复方法是：在 level 的 2D 场景下，把 entities 节点和 bullets 节点都统一放在 0，0 原点处
- 此时运行时我发现子弹生成时看起来像从远方飞过来的，关掉物理插值后该问题解决，但是角色会产生剧烈抖动，待解决

#### 动画朝向

- 完成跳跃动画逻辑后，发现小 bug：目前在向左跳跃的过程中，若在跳跃过程中松开 a 按键，会导致动画强制转向成右侧跳跃的样式
- 修改方法：新建一个控制朝向的变量，在有输入的时候监测是否需要水平轴反转，如下列逻辑：

```gdscript
func animation():
	if direction_x != 0:  //#如果存在左右方向非0
		facing = sign(direction_x)   //facing是控制朝向的变量
	$Legs.flip_h = facing < 0  //若朝向向量为负（既为左方向），此时facing为1，判断条件会返回true 则设置水平轴翻转
	...
```


##9-18 w=问题记录
 想实现角色离开检测区域后2秒内，无人机仍跟随原方向移动，后续发现是if的语句有问题，对veloity的运动使用，需要在整个func _physics_process(_delta: float) -> void:
函数种使用，只有计时器时间超过2秒，触发停止，将velocity改为vector2.zero，其余时刻都正常向last_dir  * speed 方向移动
