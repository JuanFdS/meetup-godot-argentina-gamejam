extends PathFollow2D
@onready var area_2d: Area2D = $Area2D

@export var velocidad: float = 150.0
var health: float = 25.0
var cadenas: Array = []

func _ready() -> void:
	area_2d.area_entered.connect(on_cadena_enemiga_entered)
	area_2d.area_exited.connect(on_cadena_enemiga_exited)
	$HealthBar.max_value = health
	

func on_cadena_enemiga_entered(cadena):
	cadenas.push_back(cadena)

func on_cadena_enemiga_exited(cadena):
	cadenas.erase(cadena)

func _process(delta: float) -> void:
	var velocidad_final = velocidad if cadenas.is_empty() else velocidad / (cadenas.size() + 1)
	progress += velocidad_final * delta
	$HealthBar.value = health
	

func hit_base():
	queue_free()

func damaged_by_laser(danio):
	reducir_salud(danio)

func hit_by_disparo(disparo):
	create_tween().tween_property($Sprite2D, "modulate", Color.WHITE, 0.3).from(Color.RED)
	reducir_salud(disparo.danio)

func reducir_salud(danio):
	health -= danio
	if health <= 0.0:
		queue_free()
		get_tree().get_nodes_in_group("level").front().nave_derrotada()
