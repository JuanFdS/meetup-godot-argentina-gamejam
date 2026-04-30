extends Node2D
const DISPARO = preload("uid://ddqsjy7kd6id7")

var nearby_enemies: Array = []
@onready var area_2d: Area2D = $Area2D
@export var fire_rate: float = 1.0
@onready var disparo_spawn_point: Marker2D = %DisparoSpawnPoint

var time_between_disparos: float = 1.0 / fire_rate
var time_until_next_disparo: float = 0.0

func _ready() -> void:
	area_2d.area_entered.connect(on_area_entered)
	area_2d.area_exited.connect(on_area_exited)

func on_area_entered(enemy):
	nearby_enemies.push_back(enemy)

func on_area_exited(enemy):
	nearby_enemies.erase(enemy)

func _process(delta: float) -> void:
	time_until_next_disparo = move_toward(time_until_next_disparo, 0.0, delta)
	if not nearby_enemies.is_empty():
		nearby_enemies.sort_custom(func(enemy_a, enemy_b): return enemy_a.global_position.distance_to(global_position) > enemy_b.global_position.distance_to(global_position))
		var closest_enemy = nearby_enemies.front()
		look_at(closest_enemy.global_position)
		if time_until_next_disparo <= 0.0:
			disparar()

func disparar():
	time_until_next_disparo = time_between_disparos
	var disparo = DISPARO.instantiate()
	disparo.direction = Vector2.RIGHT.rotated(rotation)
	get_parent().add_child(disparo)
	disparo.global_position = disparo_spawn_point.global_position
	
	
	
