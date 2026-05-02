class_name Torreta
extends Node2D

@onready var area_2d: Area2D = $Area2D

var asteroide: Asteroide
var nearby_enemies: Array = []

func on_area_entered(enemy):
	nearby_enemies.push_back(enemy)

func on_area_exited(enemy):
	nearby_enemies.erase(enemy)

func _ready() -> void:
	add_to_group("torreta")
	area_2d.area_entered.connect(on_area_entered)
	area_2d.area_exited.connect(on_area_exited)

func quitar_de_asteroide():
	asteroide.torreta_fue_quitada(self)
	asteroide = null

func agregada_a(un_asteroide):
	asteroide = un_asteroide
