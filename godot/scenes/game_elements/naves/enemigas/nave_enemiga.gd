extends PathFollow2D

@export var velocidad: float = 150.0
var health: int = 7

func _process(delta: float) -> void:
	progress += velocidad * delta

func hit_base():
	queue_free()

func hit_by_disparo(disparo):
	create_tween().tween_property($Sprite2D, "modulate", Color.WHITE, 0.3).from(Color.RED)
	health -= disparo.danio
	if health <= 0:
		queue_free()
