extends Control

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		get_viewport().set_input_as_handled()   # 防止同一次按键被后续场景重复响应
		get_tree().change_scene_to_file("res://scenes/levels/level.tscn")
