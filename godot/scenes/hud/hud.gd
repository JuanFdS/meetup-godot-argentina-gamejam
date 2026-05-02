extends CanvasLayer

@export var nivel: Level
@onready var start_wave_button: Button = %StartWaveButton
@onready var label_ola: Label = %LabelOla
@onready var label_oro: Label = %LabelOro
@onready var health_bar: TextureProgressBar = %HealthBar
@onready var label_enemigos: Label = %LabelEnemigos

func _ready() -> void:
	nivel.ola_comenzada.connect(on_ola_comenzada)
	nivel.ola_terminada.connect(on_ola_terminada)
	nivel.health_changed.connect(update_health)
	nivel.enemigo_derrotado.connect(on_enemigo_derrotado)
	start_wave_button.pressed.connect(on_start_wave_button_pressed)
	actualizar_texto_olas()
	update_health(nivel.health, nivel.max_health)

func update_health(new_health, max_health):
	health_bar.max_value = max_health
	health_bar.value = new_health

func on_start_wave_button_pressed():
	nivel.empezar_ola()

func on_ola_terminada():
	start_wave_button.disabled = false

func on_ola_comenzada():
	actualizar_texto_olas()
	start_wave_button.disabled = true

func on_enemigo_derrotado():
	actualizar_texto_olas()

func actualizar_texto_olas():
	label_ola.text = "%s: %2d / %2d" % [tr("Ola"), nivel.ola_actual, nivel.cantidad_olas]
	label_enemigos.text = "%s: %3d" % [tr("Enemigos"), nivel.enemigos_restantes]

func _process(_delta: float) -> void:
	label_oro.text = "%s: %4d" % [tr("Oro"), nivel.oro]
