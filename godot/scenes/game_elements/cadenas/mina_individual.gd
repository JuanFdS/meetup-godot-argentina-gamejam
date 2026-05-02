extends Node2D

var rotation_speed: float
@onready var area_2d: Area2D = $Area2D
@onready var animacion_mina: AnimatedSprite2D = $AnimacionMina
var cooldown_time: float = 1.0
var time_until_respawn: float = 0.0
@onready var area_de_danio: Area2D = $AreaDeDanio
var danio: float = 10.0

func _ready() -> void:
	rotation_speed = randf_range(-PI/2, PI/2)
	area_2d.area_entered.connect(on_area_entered)

func _process(delta: float) -> void:
	rotation += rotation_speed * delta
	time_until_respawn = move_toward(time_until_respawn, 0.0, delta)
	if not visible and time_until_respawn <= 0.0:
		area_2d.set_deferred("monitoring", true)
		visible = not is_respawning()
		create_tween().tween_property($AnimacionMina, "scale", Vector2.ONE * 0.3, 0.5).from(Vector2.ZERO).set_trans(Tween.TRANS_ELASTIC)

func is_respawning() -> bool:
	return time_until_respawn > 0

func is_exploding() -> bool:
	return animacion_mina.animation == "explode"

func on_area_entered(area):
	if is_respawning() or is_exploding():
		return
	var enemigos = area_de_danio.get_overlapping_areas().map(func(un_area): return un_area.duenio())
	animacion_mina.play("explode")
	animacion_mina.animation_finished.connect(func():
		visible = false
		for enemigo in enemigos:
			if is_instance_valid(enemigo):
				enemigo.hit_by_explosion(danio)
		animacion_mina.play("default")
		time_until_respawn = cooldown_time
	)
