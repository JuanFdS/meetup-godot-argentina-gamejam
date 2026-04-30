extends Node2D

var rotation_per_second: float

func _ready():
	rotation_per_second = PI / 12 * [-1, 1].pick_random()

func _process(delta: float) -> void:
	$Polygon2D.rotation += rotation_per_second * delta
