extends Control

func _ready() -> void:
	if Global.score == 999:
		$Label2.text = "You are Fail!"
	else:
		$Label2.text =   "Your  Highest Score is :  "+ str(Global.score)

func _physics_process(_delta: float) -> void:  #在标题页面点击空格
	if Input.is_action_just_pressed("confirm"):
		get_tree().change_scene_to_file("res://scenes/game.tscn")  #直接执行gettree执行跳转
		
		
	
