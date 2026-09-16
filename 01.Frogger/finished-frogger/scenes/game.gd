extends Node2D
var car_scene : PackedScene = preload("res://scenes/car.tscn")   #游戏场景内引用加载car场景资源
var Score := 0   

func _on_area_2d_body_entered(_body: Node2D) -> void:   #进入结算终点时
	call_deferred("change_scene") #延迟执行指定的方法。既会延迟执行切换场景的函数
	if Score < Global.score:    #当前用时越少，代表成绩越好
		Global.score = Score
	
		
	


func change_scene():    #用于改变场景
	get_tree().change_scene_to_file("res://scenes/Title.tscn")   #get_tree 方法调用场景树节点，再改变当前的场景，到对应的页面


func _on_car_timer_timeout() -> void:
	var car = car_scene.instantiate()  as Area2D #instantiate 实例化该场景的节点架构，触发子场景实例化
	var pos_marker = $CarStartPostitions.get_children().pick_random()  as Marker2D #创建新变量，在车辆起始节点的子节点的数组中用random随机选择初始位置
	car.position = pos_marker.position   #将随机选取到的初始位置赋值给当前创建的车辆实例
	$Objects.add_child(car)    #将车辆的生成放在objects节点内部
	car.connect("body_entered",go_to_title)   #先把car实例绑定其对应的信号和需要执行的函数
	
	
	
func go_to_title(_body):   #碰撞后应该直接结束游戏，返回到标题页面
	call_deferred("change_scene") #延迟执行指定的方法。既会延迟执行切换场景的函数
	

func _on_score_timer_timeout() -> void:    #Score计时器 的信号，游戏时间每持续1，都会使Score变量值+1
	Score += 1
	$CanvasLayer/Label.text = "Passed time : " + str(Score)    #调用Label展示框的text显示所需文本，再拼接上需要的得分or存活时间内容
