extends CharacterBody2D

var direction_x : float
var speed :=    100
var jump_strength := 500  #跳跃高度 
var gravity := 1500

signal shoot(pos :Vector2 , dir : Vector2 ) #新建发射信号，内部参数是子弹的位置信息和方向向量
 
func get_input():  #读取键盘输入并改
	direction_x = Input.get_axis("left","right")
	if Input.is_action_just_pressed("jump"):   #如果input检测到输入空格跳跃
		velocity.y = -jump_strength    #想要的跳跃高度，在代码中需要表示为负数
	if Input.is_action_just_pressed("shoot") and $ReloadTimer.time_left == 0:
		print("Shoot!")
		shoot.emit(position,get_local_mouse_position().normalized())     #自建信号后，需要在检测到输入后进行信号的发送
		$ReloadTimer.start()   #自行启用计时器，由于是单次触发，执行完后又不满足条件，进而进入冷却时间
		
		
func apply_gravity(delta):       #重力函数用于下落
	velocity.y += gravity * delta  #
		

func _physics_process(delta: float) -> void:
	get_input()   #必须先调用函数进行键盘输入的读取，再进行方向的移动
	velocity.x = direction_x * speed
	apply_gravity(delta)
	move_and_slide()
	
