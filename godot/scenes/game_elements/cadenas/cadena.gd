class_name Cadena
extends Line2D

var unidad

func _exit_tree() -> void:
	get_tree().get_nodes_in_group("level").front().torreta_vendida(unidad)

func _process(delta: float) -> void:
	var torretas = get_children().filter(func(torreta): return torreta.is_in_group("torreta"))
	var primera_torreta = torretas.front()
	var segunda_torreta = torretas.back()
	var point_a = primera_torreta.position
	var point_b = segunda_torreta.position
	set_point_position(0, point_a)
	set_point_position(1, point_b)
	var laser = get_children().filter(func(un_laser): return un_laser.is_in_group("laser")).front()
	laser.position = (point_a + point_b) / 2
	laser.rotation = (point_a.direction_to(point_b)).angle()
	laser.width = point_a.distance_to(point_b)
