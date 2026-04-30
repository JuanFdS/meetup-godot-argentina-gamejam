extends PathFollow2D
@onready var area_2d: Area2D = $Area2D

@export var velocidad: float = 150.0
var health: int = 25
var cadenas: Array = []

func _ready() -> void:
	area_2d.area_entered.connect(on_cadena_enemiga_entered)
	area_2d.area_exited.connect(on_cadena_enemiga_exited)

func on_cadena_enemiga_entered(cadena):
	cadenas.push_back(cadena)

func on_cadena_enemiga_exited(cadena):
	cadenas.erase(cadena)

func _process(delta: float) -> void:
	var velocidad_final = velocidad if cadenas.is_empty() else velocidad / (cadenas.size() + 1)
	progress += velocidad_final * delta
	

func hit_base():
	queue_free()

func hit_by_disparo(disparo):
	create_tween().tween_property($Sprite2D, "modulate", Color.WHITE, 0.3).from(Color.RED)
	health -= disparo.danio
	if health <= 0:
		queue_free()
