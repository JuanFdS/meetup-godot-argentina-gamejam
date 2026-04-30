class_name Camino
extends Node2D

@export var path: Path2D

func _ready():
	if not path and has_node("Path2D"):
		path = get_node("Path2D")

func agregar_nave(nave):
	path.add_child(nave)
