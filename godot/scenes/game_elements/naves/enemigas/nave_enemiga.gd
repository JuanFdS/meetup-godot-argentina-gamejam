class_name NaveEnemiga
extends PathFollow2D
@onready var area_2d: Area2D = $Area2D

enum Tipo {
	Inglesa,
	Basica,
	Francesa,
	Rapida
}

var tipo = Tipo.Inglesa

@export var velocidad: float = 150.0
var health: float = 25.0
var cadenas: Array = []
var danio: float = 20

func _ready() -> void:
	h_offset = randf_range(-25, 75)
	v_offset = randf_range(-50, 50)
	match tipo:
		Tipo.Inglesa:
			$Imagen/Inglesa.visible = true
			health = 25
			velocidad = 100
			danio = 20
		Tipo.Basica:
			$Imagen/Basica.visible = true
			health = 37.5
			velocidad = 100
			danio = 30
		Tipo.Francesa:
			$Imagen/Francesa.visible = true
			health = 62.5
			velocidad = 70
			danio = 40
		Tipo.Rapida:
			$Imagen/Rapida.visible = true
			health = 17.5
			velocidad = 200
			danio = 10
	area_2d.area_entered.connect(on_cadena_enemiga_entered)
	area_2d.area_exited.connect(on_cadena_enemiga_exited)
	$HealthBar.max_value = health
	$HealthBar.visible = false

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

func damaged_by_laser(un_danio):
	reducir_salud(un_danio)

func hit_by_disparo(disparo):
	create_tween().tween_property($Imagen, "modulate", Color.WHITE, 0.3).from(Color.RED)
	reducir_salud(disparo.danio)

func hit_by_explosion(un_danio):
	create_tween().tween_property($Imagen, "modulate", Color.WHITE, 0.3).from(Color.RED)
	reducir_salud(un_danio)

func reducir_salud(un_danio):
	$HealthBar.visible = true
	health -= un_danio
	if health <= 0.0:
		queue_free()
		get_tree().get_nodes_in_group("level").front().nave_derrotada()
