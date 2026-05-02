class_name Asteroide
extends Node2D

@export var capacidad_de_torretas: int = 1
var rotation_per_second: float
var torretas: Array[Node] = []
var pos_por_torreta: Dictionary

func _ready():
	add_to_group("asteroide")
	$Polygon2D/Area2D.asteroide = self
	rotation_per_second = PI / 12 * [-1, 1].pick_random()

func _process(delta: float) -> void:
	$Sprite2D.rotation += rotation_per_second * delta
	$Polygon2D.rotation += rotation_per_second * delta
	for torreta in torretas:
		if torreta.process_mode != PROCESS_MODE_DISABLED:
			if not pos_por_torreta.has(torreta):
				pos_por_torreta[torreta] = $Sprite2D.to_local(torreta.global_position)
			torreta.global_position = $Sprite2D.to_global(pos_por_torreta[torreta])

func agregar_torreta(torreta):
	torretas.push_back(torreta)
	torreta.tree_exited.connect(func():
		if torreta in torretas:
			torretas.erase(torreta)
		pos_por_torreta.erase(torreta)
	)
	torreta.agregada_a(self)


func torreta_fue_quitada(torreta):
	torretas.erase(torreta)
	pos_por_torreta.erase(torreta)

func esta_libre():
	return torretas.size() < capacidad_de_torretas
