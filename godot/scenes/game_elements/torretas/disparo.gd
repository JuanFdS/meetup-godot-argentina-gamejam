extends Node2D
@onready var area_2d: Area2D = $Area2D
@export var danio: float = 0.4
@export var velocidad: float = 750.0
var direction: Vector2

func _ready():
	area_2d.area_entered.connect(on_area_entered)
	rotation = direction.angle()

func on_area_entered(area):
	area.hit_by_disparo(self)
	queue_free()

func _process(delta: float) -> void:
	global_position += direction * velocidad * delta
