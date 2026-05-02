extends Node2D
@onready var area_2d: Area2D = $Area2D
var danio: float = 0.4 # se lo setea la metralleta igual
@export var velocidad: float = 750.0
var direction: Vector2

func _ready():
	area_2d.area_entered.connect(on_area_entered)
	rotation = direction.angle()

func on_area_entered(area):
	if is_queued_for_deletion():
		return
	area.hit_by_disparo(self)
	queue_free()
	var particles = $GPUParticles2D
	particles.reparent(get_parent())
	particles.global_position = $Marker2D.global_position
	particles.global_rotation = global_rotation
	particles.restart()

func _process(delta: float) -> void:
	global_position += direction * velocidad * delta
