extends Node2D

@onready var area_2d: Area2D = $Area2D

signal damaged(damage)

func _ready():
	area_2d.area_entered.connect(on_enemy_entered)

func on_enemy_entered(enemy):
	enemy.hit_base()
	damaged.emit(enemy.duenio().danio)
