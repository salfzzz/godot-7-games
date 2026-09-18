extends Node2D

var bullet_scene = preload("res://scenes/bullets/bullet.tscn")

func _ready() -> void:
	var light_tween = create_tween()
	light_tween.set_loops()
	light_tween.tween_property($Light/GreenLight5,"energy",1.5,0.3)
	light_tween.tween_property($Light/GreenLight5,"energy",0.3,0.3)
	light_tween.tween_property($Light/GreenLight10,"energy",1.5,0.3)
	light_tween.tween_property($Light/GreenLight10,"energy",0.3,0.3)


func _on_player_shoot(pos: Vector2, dir: Vector2) -> void: #角色的发射信号
	var bullet = bullet_scene.instantiate() as Area2D
	$Bullets.add_child(bullet)
	bullet.setup(pos,dir)
