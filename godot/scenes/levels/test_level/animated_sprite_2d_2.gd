extends AnimatedSprite2D

var rotation_per_second

func _ready() -> void:
	rotation_per_second = PI / 36 * [-1, 1].pick_random() 

func _process(delta: float) -> void:
	rotation += rotation_per_second * delta
