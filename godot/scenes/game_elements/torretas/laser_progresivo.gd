class_name LaserProgresivo
extends Torreta

@export var fire_rate: float = 5.0
@onready var disparo_spawn_point: Marker2D = %DisparoSpawnPoint
@onready var laser_cabeza: AnimatedSprite2D = $LaserCabeza
@onready var laser_line: Line2D = %LaserLine
var enemy_being_shot: Node2D

var max_damage_per_second: float = 10.0
var damage_acceleration: float = 2.0
var current_damage_per_second: float
var time_between_disparos: float = 1.0 / fire_rate
var time_until_next_disparo: float = 0.0

func _process(delta: float) -> void:
	time_until_next_disparo = move_toward(time_until_next_disparo, 0.0, delta)
	laser_cabeza.speed_scale = remap(current_damage_per_second, 0.0, max_damage_per_second, 0.0, 5.0)

	if nearby_enemies.is_empty():
		enemy_being_shot = null
		current_damage_per_second = 0.0
	elif enemy_being_shot == null:
		var candidates = nearby_enemies.map(func(area): return area.get_parent())
		candidates.sort_custom(func(enemy_a, enemy_b):
			return enemy_a.health < enemy_b.health
		)
		enemy_being_shot = candidates.front()

	laser_line.visible = !!enemy_being_shot
	laser_line.default_color.g = remap(current_damage_per_second, 0.0, max_damage_per_second, 1.0, 0.0)
	laser_line.default_color.b = remap(current_damage_per_second, 0.0, max_damage_per_second, 1.0, 0.0)
	
	if enemy_being_shot:
		laser_cabeza.look_at(enemy_being_shot.global_position)
		current_damage_per_second = move_toward(current_damage_per_second, max_damage_per_second, delta * damage_acceleration)
		laser_line.set_point_position(
			laser_line.get_point_count() - 1,
			laser_line.to_local(
				lerp(
					disparo_spawn_point.global_position,
					enemy_being_shot.global_position,
					min(remap(pow(current_damage_per_second, 3), 0.0, 1.0, 0.0, 1.0), 1.0)
				)
		)
		)
		enemy_being_shot.damaged_by_laser(delta * current_damage_per_second)
