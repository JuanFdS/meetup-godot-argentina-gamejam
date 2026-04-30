class_name Level
extends Node2D

signal ola_comenzada
signal ola_terminada
signal health_changed(new_health, max_health)
signal enemigo_derrotado

const NAVE_ENEMIGA = preload("uid://0ct48bf06lp1")

var max_health: float = 100.0
var health: float = max_health
@onready var game_over_message: Control = %GameOverMessage

@onready var base: Node2D = %Base
@export var olas: int = 5
var ola_actual: int = 0
var ola_en_progreso: bool = false
@export var caminos: Array[Camino]
@onready var camera_2d: Camera2D = $Camera2D

var enemigos_por_ola: int = 5

var tiempo_entre_enemigos: float = 5.0
var tiempo_hasta_proximo_enemigo: float = tiempo_entre_enemigos
var enemigos_por_spawnear: int = 0
var enemigos_actuales: Array = []
var enemigos_restantes :
	get():
		return enemigos_por_spawnear + enemigos_actuales.size()

func _ready():
	base.damaged.connect(on_base_damaged)

func on_base_damaged(damage):
	health -= damage
	camera_2d.add_shake()
	health_changed.emit(health, max_health)
	if health <= 0:
		lose()

func empezar_ola():
	ola_actual += 1
	ola_en_progreso = true
	tiempo_hasta_proximo_enemigo = 0
	enemigos_por_spawnear = enemigos_por_ola
	ola_comenzada.emit()

func _process(delta: float) -> void:
	if not ola_en_progreso:
		return
	tiempo_hasta_proximo_enemigo = move_toward(tiempo_hasta_proximo_enemigo, 0, delta)
	if tiempo_hasta_proximo_enemigo <= 0.0 and enemigos_por_spawnear > 0:
		var camino = caminos.front()
		var nave_enemiga = NAVE_ENEMIGA.instantiate()
		camino.agregar_nave(nave_enemiga)
		enemigos_actuales.push_back(nave_enemiga)
		enemigos_por_spawnear -= 1
		nave_enemiga.tree_exited.connect(func(): on_nave_enemiga_exited(nave_enemiga))
		tiempo_hasta_proximo_enemigo = tiempo_entre_enemigos

func on_nave_enemiga_exited(nave_enemiga):
	enemigos_actuales.erase(nave_enemiga)
	enemigo_derrotado.emit()
	if enemigos_por_spawnear == 0 and enemigos_actuales.is_empty():
		enemigos_por_ola += 3
		tiempo_entre_enemigos -= 0.3
		ola_en_progreso = false
		ola_terminada.emit()
		if ola_actual >= olas:
			win()

func win():
	game_over_message.win()
	get_tree().paused = true

func lose():
	game_over_message.lose()
	get_tree().paused = true
