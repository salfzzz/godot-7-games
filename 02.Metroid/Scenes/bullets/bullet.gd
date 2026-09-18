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


func _on_body_entered(body: Node2D) -> void:  #一旦检测到实体发生碰撞，则消除子弹（无论是碰到地形还是碰到无人机）
	if"hit" in body:
		body.hit()   #触发无人机脚本下的hit函数，地形脚本不存咋该函数，所以不会触发hit函数
	queue_free()
	
