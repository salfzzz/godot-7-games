extends CharacterBody2D

var direction :=  Vector2.ZERO
var speed :int = 150
var saysomeshting : String

func _physics_process(delta: float) -> void:
	direction = Input.get_vector("left","right","up","down") #get_vector方法能读取四个方向，-x是left，+x是right。-y是up，+y是down
	velocity = direction * speed 
	animation()
	move_and_slide() #根据计算的velocity自动移动物体
	 # position += direction * speed * delta  直接修改position的写法没有碰撞检测，需要用characterbody自带的
	
	#if Input.is_action_just_pressed("confirm"):   #按下按键的一瞬间只执行一次 ，与 is_action_pressed 区分：，按下按键后每一帧都会执行相关指令
		#print("hello world")
	
func animation():      #调用动画的函数
	if direction:     # 如果存在方向移动 
		$AnimatedSprite2D.flip_h = direction.x > 0   #用direction.x的正负直接传输true 和false ，控制是否实现翻转
		if direction.x != 0:
			$AnimatedSprite2D.animation = "left"  #播放导入的”left“动画帧，并且翻转逻辑仍存在
		else:
			$AnimatedSprite2D.animation = "up" if direction.y < 0 else "down" #三元表达式, 如果y分量小于0，则播放up动画，否则播放down动画
			
			#if direction.y < 0 :  较复杂的实现上与下动画切换的方法
				#$AnimatedSprite2D.animation = "up"   #若角色向上移动，y分量小于0，执行导入的”up“动画
			#else:
				#$AnimatedSprite2D.animation = "down"
				
				
		#if direction.x> 0:     	 #较复杂的写法 若此时x轴方向向右移动
			#$AnimatedSprite2D.flip_h = true  #则反转动画，播放右走动画
		#else:
			#$AnimatedSprite2D.flip_h = false #若x轴方向仍然向左，则不反转水平轴动画，继续播放左走动画
		
	else:
		$AnimatedSprite2D.frame = 0   #一直保持在停止的动画帧上
	
	
	
	
