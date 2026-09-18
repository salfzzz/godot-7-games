extends CharacterBody2D

var direction : Vector2
var speed : int = 100   #控制无人机速度
var player : CharacterBody2D    #识别无人机实体
var is_active : bool = false    #无人机是否还能继续行动
var last_dir := Vector2.ZERO    #最后无人机运动的方向
var health := 3					#无人机的生命值

func _on_detection_area_body_entered(body: CharacterBody2D) -> void:
	player = body  #将角色实际的实体传入全局变量player中
	is_active = true
	$LastTimer.stop()    #如果角色进入检测区域时，此时不打开计时器
	
func _on_detection_area_body_exited(_body: CharacterBody2D) -> void:
	player = null   #逻辑是当无人机不在检测到角色在范围内，则将全局变量player1的值变为0，这样无人机就会停止移动
	$LastTimer.start()	  #一旦检测到角色离开了检测区域，此时开始启动该计时器，一但离开超过2秒，is——active变量设置为false
	
	
func _physics_process(_delta: float) -> void:
	if not is_active:   #如果设定的持续追踪时间结束后仍未再检测到角色，
		velocity = Vector2.ZERO    #则移动量改为0
		return
	
	if player:
		last_dir = (player.position - position).normalized()    #根据两个坐标的差值确定方向朝向，再归一化独处理
	velocity = last_dir * speed 
	move_and_slide()


func _on_last_timer_timeout() -> void:   #设置计时器的信号量，一旦2秒时间结束，则对应的变量设置为false
	is_active = false


func _on_collision_area_body_entered(_body: Node2D) -> void:  #一旦无人机爆炸检测范围检测到角色进入，则播放爆炸动画
	explode()
	
	
func hit():
	health -= 1
	if health <= 0:
		explode()
	
func explode():  #专门用于处理爆炸销毁的函数
		speed = 0   #无人机速度降为0
		$AnimatedSprite2D.hide() #将原本的无人机贴图视为不可见
		$ExpolsionSprite.show()  #播放默认隐藏后的爆炸动画
		$AnimationPlayer.play("explorde") #进入爆炸检测范围后播放爆炸动画
		await $AnimationPlayer.animation_finished  #在等待爆炸动画播放完毕之后（用await来等待animationplayer默认的finished函数）
		for drone in get_tree().get_nodes_in_group("无人机"):
			if position.distance_to(drone.position) < 20 :
				drone.explode()
		queue_free()   #删除无人机自身节点
		
func change_reaction():  #用于优化连锁爆炸的样式 ，不需要连锁爆炸的无人机再执行不必要的爆炸逻辑
	for drone in get_tree().get_nodes_in_group("无人机"):
		if position.distance_to(drone.position) < 20 :
			drone.explode()		
