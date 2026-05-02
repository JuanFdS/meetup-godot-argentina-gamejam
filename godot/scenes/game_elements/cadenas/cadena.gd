class_name Cadena
extends Line2D

const LABEL_GOLDUP = preload("uid://2ggey1bfqj55")
var unidad
@onready var torretas = get_children().filter(func(torreta): return torreta.is_in_group("torreta"))
@onready var laser = get_children().filter(func(un_laser): return un_laser.is_in_group("laser")).front()
var desplegada: bool = false

func _exit_tree() -> void:
	if not desplegada:
		return
	var gold_up_label = LABEL_GOLDUP.instantiate()
	get_parent().get_parent().add_child(gold_up_label)
	gold_up_label.global_position = get_global_mouse_position() + Vector2(25, -25)
	gold_up_label.start(unidad.costo_total())
	get_tree().get_nodes_in_group("level").front().torreta_vendida(unidad)

func _process(delta: float) -> void:
	var primera_torreta = torretas.front()
	var segunda_torreta = torretas.back()
	var point_a = primera_torreta.position
	var point_b = segunda_torreta.position
	set_point_position(0, point_a)
	set_point_position(1, point_b)
	laser.position = (point_a + point_b) / 2
	laser.rotation = (point_a.direction_to(point_b)).angle()
	laser.width = point_a.distance_to(point_b)
