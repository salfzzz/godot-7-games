extends Area2D
var directon : Vector2
var speed := 150
func setup(pos:Vector2,dir:Vector2):
	position = pos + dir * 16
	directon = dir


func _ready() -> void:
	var tweens = get_tree().create_tween()
	tweens.tween_property($Sprite2D,"scale",Vector2.ONE,0.5).from(Vector2.ZERO )

func _physics_process(delta: float) -> void:
	position += directon * speed * delta
