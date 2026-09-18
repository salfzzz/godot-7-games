extends CharacterBody2D

var direction_x : float
var speed :=    120
var jump_strength := 500  #跳跃高度 
var gravity := 1500
var facing := 1  #控制左右朝向的变量

const gun_directions = {        #用于控制枪械朝向的字典
	Vector2i(1,0) : 0 ,	
	Vector2i(1,1) : 1 ,	
	Vector2i(0,1) : 2 ,	
	Vector2i(-1,1) : 3 ,	
	Vector2i(-1,0) : 4 ,	
	Vector2i(-1,-1) : 5 ,	
	Vector2i(0,-1) : 6 ,	
	Vector2i(1,-1) : 7 
	
}

signal shoot(pos :Vector2 , dir : Vector2 ) #新建发射信号，内部参数是子弹的位置信息和方向向量
 
func get_input():  #读取键盘输入并改
	direction_x = Input.get_axis("left","right")
	if Input.is_action_just_pressed("jump") and is_on_floor():   #如果input检测到输入空格跳跃
		velocity.y = -jump_strength    #想要的跳跃高度，在代码中需要表示为负数
	if Input.is_action_just_pressed("shoot") and $ReloadTimer.time_left == 0:
		print("Shoot!")
		shoot.emit(position,get_local_mouse_position().normalized())     #自建信号后，需要在检测到输入后进行信号的发送
		$ReloadTimer.start()   #自行启用计时器，由于是单次触发，执行完后又不满足条件，进而进入冷却时间
		var tween = get_tree().create_tween()  #新建tween子实例，通过调用gettree函数，创建tween来赋值给新的tweene实例
		tween.tween_property($Marker , "scale", Vector2(0.1,0.1) , 0.2)   #准星缩小动画，持续0.2秒
		tween.tween_property($Marker , "scale", Vector2(0.3,0.3) , 0.4)   #准星还原动画，持续0.2秒
		
		
func animation():
	#$Legs.flip_h = direction_x < 0   空中不按按键会强制变成右方动画，存在bug
	#
	if direction_x != 0 :  #如果存在左右方向非0
		facing = sign(direction_x)   #facing的值设置为单位值 1，—1 或0
		$Legs.flip_h = facing < 0   #若朝向向量为负（既为左方向）则设置水平轴翻转
		
	if is_on_floor():  
		$AnimationPlayer.current_animation = "Run" if direction_x != 0 else "idle"	
	else :
		$AnimationPlayer.current_animation = "jump"
	var raw_dir = get_local_mouse_position().normalized()   #获取鼠标指向的方向向量
	var adjust_dir  = Vector2i(round(raw_dir.x), round(raw_dir.y))
	$Torso.frame = gun_directions[adjust_dir]
		
func apply_gravity(delta):       #重力函数用于下落
	velocity.y += gravity * delta  #

func update_marker():
	$Marker.position = get_local_mouse_position().normalized() * 40  #更新准星所在的位置

func _physics_process(delta: float) -> void:
	get_input()   #必须先调用函数进行键盘输入的读取，再进行方向的移动
	velocity.x = direction_x * speed
	apply_gravity(delta)
	move_and_slide()
	animation()
	update_marker()
	
	

	
