class_name Cadena
extends Line2D

var unidad

func _exit_tree() -> void:
	get_tree().get_nodes_in_group("level").front().torreta_vendida(unidad)
