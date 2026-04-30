class_name Star
extends Sprite2D

var rotation_per_second: float

func _ready():
	rotation_per_second = (PI / 12) * [-1, 1].pick_random() * randf()

func _process(delta: float) -> void:
	rotation += rotation_per_second * delta
