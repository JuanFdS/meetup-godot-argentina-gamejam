class_name Torreta
extends Node2D
const DISPARO = preload("uid://ddqsjy7kd6id7")

var nearby_enemies: Array = []
@onready var area_2d: Area2D = $Area2D
@export var fire_rate: float = 5.0
@onready var disparo_spawn_point: Marker2D = %DisparoSpawnPoint
var shooting: bool = false

var time_between_disparos: float = 1.0 / fire_rate
var time_until_next_disparo: float = 0.0
var asteroide: Asteroide

func _ready() -> void:
	add_to_group("torreta")
	area_2d.area_entered.connect(on_area_entered)
	area_2d.area_exited.connect(on_area_exited)

func on_area_entered(enemy):
	nearby_enemies.push_back(enemy)

func on_area_exited(enemy):
	nearby_enemies.erase(enemy)

func quitar_de_asteroide():
	asteroide.torreta_fue_quitada(self)
	asteroide = null
	

func agregada_a(un_asteroide):
	asteroide = un_asteroide

func _process(delta: float) -> void:
	time_until_next_disparo = move_toward(time_until_next_disparo, 0.0, delta)
	shooting = not nearby_enemies.is_empty()
	if shooting:
		nearby_enemies.sort_custom(func(enemy_a, enemy_b): return enemy_a.global_position.distance_to(global_position) > enemy_b.global_position.distance_to(global_position))
		var closest_enemy = nearby_enemies.front()
		$AnimatedSprite2D.flip_h = closest_enemy.global_position.x > global_position.x
		if time_until_next_disparo <= 0.0:
			disparar(closest_enemy)
		$AnimatedSprite2D.play("default")
	else:
		$AnimatedSprite2D.stop()

func disparar(enemy):
	time_until_next_disparo = time_between_disparos
	var disparo = DISPARO.instantiate()
	var spawn_position = Vector2()
	spawn_position.y = disparo_spawn_point.global_position.y
	spawn_position.x = to_global(disparo_spawn_point.position * (1 if $AnimatedSprite2D.flip_h else -1)).x
	disparo.direction = spawn_position.direction_to(enemy.global_position)
	get_parent().add_child(disparo)
	disparo.global_position = spawn_position
		
	
	
	
