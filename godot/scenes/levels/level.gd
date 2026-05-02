class_name Level
extends Node2D
const INTRO_NIVEL = preload("uid://bcwmqikww8f5f")

enum Mode {
	Planning,
	Battling
}

signal ola_comenzada
signal ola_terminada
signal health_changed(new_health, max_health)
signal enemigo_derrotado

const NAVE_ENEMIGA = preload("uid://0ct48bf06lp1")

var mode: Level.Mode = Mode.Planning
var max_health: float = 100.0
var health: float = max_health
@onready var game_over_message: Control = %GameOverMessage

@onready var base: Node2D = %Base
var cantidad_olas: int :
	get():
		return olas().size()
var ola_actual: int = 0
var ola_actual_contenido = []
var proximo_evento

@export var caminos: Array[Camino]
@onready var camera_2d: Camera2D = $Camera2D
@onready var music: Music = %Music

var oro: float = 25

var tiempo_desde_ola_empezada: float = 0.0

var tiempo_entre_enemigos: float = 5.0
var enemigos_por_spawnear: int = 0
var enemigos_actuales: Array = []
var enemigos_restantes :
	get():
		return enemigos_por_spawnear + enemigos_actuales.size()

func _ready():
	$AsteroidesAPartirDeOla2.visible = false
	$AsteroidesAPartirDeOla2.process_mode = Node.PROCESS_MODE_DISABLED
	$AsteroidesAPartirDeOla4.visible = false
	$AsteroidesAPartirDeOla4.process_mode = Node.PROCESS_MODE_DISABLED
	%DibujadorDeCadenas.visible = false
	base.damaged.connect(on_base_damaged)
	music.play(mode)
	DialogueManager.show_dialogue_balloon(INTRO_NIVEL)
	await DialogueManager.dialogue_ended
	$Camino.start()
	%DibujadorDeCadenas.visible = true

func nave_derrotada(oro_ganado):
	oro += oro_ganado
	camera_2d.add_shake(7.5)

func torreta_desplegada(unidad):
	oro -= unidad.costo_total()

func torreta_vendida(unidad):
	oro += unidad.costo_total()

func on_base_damaged(damage):
	health -= damage
	camera_2d.add_shake()
	health_changed.emit(health, max_health)
	if health <= 0:
		lose()

func change_mode(new_mode: Level.Mode):
	mode = new_mode
	match mode:
		Level.Mode.Battling:
			ola_comenzada.emit()
		Level.Mode.Planning:
			ola_terminada.emit()
	music.play(mode)

func empezar_ola():
	ola_actual += 1
	ola_actual_contenido = olas()[ola_actual - 1].call()
	enemigos_por_spawnear = calcular_enemigos_por_spawnear(ola_actual_contenido)
	proximo_evento = ola_actual_contenido.pop_front()
	tiempo_desde_ola_empezada = 0.0
	change_mode(Level.Mode.Battling)

func calcular_enemigos_por_spawnear(una_ola):
	var total = 0
	for evento in una_ola:
		var tipos_de_enemigos = evento[1]
		total += tipos_de_enemigos.size()
	return total

func _process(delta: float) -> void:
	if Level.Mode.Planning == mode:
		return
	tiempo_desde_ola_empezada += delta
	if not proximo_evento:
		return
	var tiempo_proximo_evento = proximo_evento[0]
	if tiempo_proximo_evento < tiempo_desde_ola_empezada:
		var tipos_enemigos = proximo_evento[1]
		var camino = proximo_evento[2]
		for tipo_enemigo in tipos_enemigos:
			var nave_enemiga = NAVE_ENEMIGA.instantiate()
			nave_enemiga.tipo = tipo_enemigo
			camino.agregar_nave(nave_enemiga)
			enemigos_actuales.push_back(nave_enemiga)
			enemigos_por_spawnear -= 1
			nave_enemiga.tree_exited.connect(func(): on_nave_enemiga_exited(nave_enemiga))
		proximo_evento = ola_actual_contenido.pop_front()


func on_nave_enemiga_exited(nave_enemiga):
	enemigos_actuales.erase(nave_enemiga)
	enemigo_derrotado.emit()
	if enemigos_por_spawnear == 0 and enemigos_actuales.is_empty():
		change_mode(Level.Mode.Planning)
		DialogueManager.show_dialogue_balloon(INTRO_NIVEL, "ganada_ola_%s" % ola_actual)
		await DialogueManager.dialogue_ended
		if ola_actual >= cantidad_olas:
			win()

func win():
	game_over_message.win()
	get_tree().paused = true

func lose():
	game_over_message.lose()
	get_tree().paused = true

func varias(n, tipo):
	var array = []
	for i in range(n):
		array.append(tipo)
	return array

func seguidilla(segundo_inicial: float, iteraciones: int, cada_segundos: int, tipo: NaveEnemiga.Tipo, camino: Camino):
	var tiempo = segundo_inicial
	var array = []
	for i in range(iteraciones):
		array.append([tiempo, [tipo], camino])
		tiempo += cada_segundos
	return array

func olas():
	return [ola_1, ola_2, ola_3, ola_4]

func ola_1():
	var camino_1 = $Camino
	return seguidilla(1, 10, 3.5, NaveEnemiga.Tipo.Inglesa, camino_1)

func ola_2():
	var camino_1 = $Camino
	return seguidilla(1, 12, 2, NaveEnemiga.Tipo.Inglesa, camino_1)

func ola_3():
	var camino_1 = $Camino
	return seguidilla(1, 15, 2, NaveEnemiga.Tipo.Inglesa, camino_1) + seguidilla(32, 15, 2, NaveEnemiga.Tipo.Basica, camino_1)

func ola_4():
	var camino_1 = $Camino
	return seguidilla(1, 15, 2, NaveEnemiga.Tipo.Inglesa, camino_1) + seguidilla(32, 15, 2, NaveEnemiga.Tipo.Basica, camino_1)

func habilitar_segundo_camino():
	$Camino2.start()
	entrar_asteroides(
		$AsteroidesAPartirDeOla4,
		[$AsteroidesAPartirDeOla4/Asteroide5],
		[$AsteroidesAPartirDeOla4/Asteroide3, $AsteroidesAPartirDeOla4/Asteroide6, $AsteroidesAPartirDeOla4/Asteroide4]
	)
	

func entrar_asteroides_para_ola_2():
	entrar_asteroides(
		$AsteroidesAPartirDeOla2,
		[$AsteroidesAPartirDeOla2/Asteroide3, $AsteroidesAPartirDeOla2/Asteroide6],
		[$AsteroidesAPartirDeOla2/Asteroide4, $AsteroidesAPartirDeOla2/Asteroide5])
	
func entrar_asteroides(contenedor, asteroides_izq, asteroides_der):
	contenedor.process_mode = Node.PROCESS_MODE_INHERIT
	contenedor.visible = true
	for asteroide in asteroides_izq:
		var duration = randf_range(1.0, 3.0)
		create_tween().tween_property(asteroide, "global_position", asteroide.global_position, duration)\
			.from($LeftBlackHole.global_position).set_trans(Tween.TRANS_QUAD)
		create_tween().tween_property(asteroide, "scale", Vector2.ONE, duration)\
			.from(Vector2.ZERO).set_trans(Tween.TRANS_QUAD)
	for asteroide in asteroides_der:
		var duration = randf_range(1.0, 3.0)
		create_tween().tween_property(asteroide, "global_position", asteroide.global_position, duration)\
			.from($RightBlackHole.global_position).set_trans(Tween.TRANS_QUAD)
		create_tween().tween_property(asteroide, "scale", Vector2.ONE, duration)\
					.from(Vector2.ZERO).set_trans(Tween.TRANS_QUAD)
	await get_tree().create_timer(3.0).timeout

func habilitar_nueva_torreta_y_cadenas():
	for button in [
		$HUD/Control/SelectorDeUnidades/VBoxContainer/HBoxContainer/Cadenas/TextureButton,
		$HUD/Control/SelectorDeUnidades/VBoxContainer/HBoxContainer/Cadenas/TextureButton2,
		$HUD/Control/SelectorDeUnidades/VBoxContainer/HBoxContainer/Torretas/TextureButton2
	]:
		button.visible = true
