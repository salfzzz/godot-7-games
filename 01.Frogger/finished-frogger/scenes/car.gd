extends Area2D

var direction = Vector2.LEFT  # 默认车辆向左移动
var speed 	 := 200
var colors = [preload("res://graphics/cars/green.png"),
			  preload("res://graphics/cars/red.png"),										
			  preload("res://graphics/cars/yellow.png"),											]

func _ready() -> void:  #注意时序问题，ready函数只在节点被添加进场景树是才执行，所以game中要先进行随机初始化，再加入运行实例
	if position.x < 192:  # 如果随机到的初始位置在中切线左侧，则调整车辆运行方向，变为向右开
		direction.x = 1
		$Sprite2D.flip_h = true #车辆从左侧生成时，车辆贴图方向应该向右
	$Sprite2D.texture = colors.pick_random()	

func _process(delta: float) -> void:
	position  += direction * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()   #销毁驶出屏幕的车辆 通过VisibleOnscreenNotifier 节点和其exited信号完成
