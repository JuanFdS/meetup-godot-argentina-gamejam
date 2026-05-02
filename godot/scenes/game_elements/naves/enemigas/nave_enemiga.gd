class_name NaveEnemiga
extends PathFollow2D
@onready var area_2d: Area2D = $Area2D

const DANIO_CADENA_LASER_POR_SEGUNDO = 3

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
var oro: int = 5

func _ready() -> void:
	h_offset = randf_range(-25, 75)
	v_offset = randf_range(-50, 50)
	match tipo:
		Tipo.Inglesa:
			$Imagen/Inglesa.visible = true
			health = 25
			velocidad = 70
			danio = 20
			oro = 3
		Tipo.Basica:
			$Imagen/Basica.visible = true
			health = 37.5
			velocidad = 70
			danio = 30
			oro = 5
		Tipo.Francesa:
			$Imagen/Francesa.visible = true
			health = 62.5
			velocidad = 50
			danio = 40
			oro = 7
		Tipo.Rapida:
			$Imagen/Rapida.visible = true
			health = 17.5
			velocidad = 150
			danio = 10
			oro = 4
	area_2d.area_entered.connect(on_cadena_enemiga_entered)
	area_2d.area_exited.connect(on_cadena_enemiga_exited)
	$HealthBar.max_value = health
	$HealthBar.visible = false

func on_cadena_enemiga_entered(cadena):
	cadenas.push_back(cadena)

func on_cadena_enemiga_exited(cadena):
	cadenas.erase(cadena)

func _process(delta: float) -> void:
	var cantidad_realentizacion: int = 0
	var cantidad_fuego_laser: int = 0
	var hay_alguna_cadena = not cadenas.is_empty()
	if hay_alguna_cadena:
		for cadena in cadenas:
			if cadena.is_in_group("ventilador"):
				cantidad_realentizacion += 1
			if cadena.is_in_group("fuego_laser"):
				cantidad_fuego_laser += 1
	var velocidad_final = velocidad / (cantidad_realentizacion + 1)
	if cantidad_fuego_laser > 0:
		damaged_by_laser(cantidad_fuego_laser * DANIO_CADENA_LASER_POR_SEGUNDO * delta)
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
		var particles = $GPUParticles2D
		particles.reparent(get_parent())
		particles.global_position = global_position
		particles.restart()
		var gold_up_label = $Label
		gold_up_label.reparent(get_parent())
		gold_up_label.global_position = global_position
		gold_up_label.start(oro)
		get_tree().get_nodes_in_group("level").front().nave_derrotada(oro)
