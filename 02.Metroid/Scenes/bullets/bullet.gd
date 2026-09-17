extends Area2D
var directon : Vector2
var speed := 300
func setup(pos:Vector2,dir:Vector2):
	position = pos + dir * 16
	directon = dir

func _physics_process(delta: float) -> void:
	position += directon * speed * delta
