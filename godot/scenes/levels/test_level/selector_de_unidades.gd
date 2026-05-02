extends PanelContainer

var selected_torreta_button: TextureButton
var selected_cadena_button: TextureButton
@onready var torretas: VBoxContainer = $VBoxContainer/HBoxContainer/Torretas
@onready var cadenas: VBoxContainer = $VBoxContainer/HBoxContainer/Cadenas
@onready var costo_total_label: RichTextLabel = $VBoxContainer/CostoTotalLabel
var torretas_buttons: Array
var cadenas_buttons: Array

var all_buttons: Array = []
@onready var unidad_tooltip: RichTextLabel = $"../UnidadTooltip"
@onready var dibujador_de_cadenas: DibujadorDeCadenas = %DibujadorDeCadenas

class UnidadSeleccionada:
	extends RefCounted

	var torreta_button: TextureButton
	var cadena_button: TextureButton
	var torreta_scene:
		get():
			return torreta_button.scene
	
	func _init(_torreta_button, _cadena_button) -> void:
		torreta_button = _torreta_button
		cadena_button = _cadena_button
	
	func costo_total():
		return torreta_button.cost + cadena_button.cost

func obtener_unidad():
	return UnidadSeleccionada.new(
		selected_torreta_button,
		selected_cadena_button)

func _ready():
	for button in torretas.find_children("", "TextureButton", true, false):
		torretas_buttons.push_back(button)
		button.pressed.connect(elegir_torreta.bind(button))
	for button in cadenas.find_children("", "TextureButton", true, false):
		cadenas_buttons.push_back(button)
		button.pressed.connect(elegir_cadena.bind(button))
	all_buttons = torretas_buttons + cadenas_buttons
	elegir_torreta(torretas_buttons.front())
	elegir_cadena(cadenas_buttons.front())

func elegir_torreta(boton):
	selected_torreta_button = boton
	dibujador_de_cadenas.unidad_actual = obtener_unidad()
	
func elegir_cadena(boton):
	selected_cadena_button = boton
	dibujador_de_cadenas.unidad_actual = obtener_unidad()

func _process(delta: float) -> void:
	unidad_tooltip.visible = false
	for button in all_buttons:
		if button.is_hovered():
			unidad_tooltip.visible = true
			unidad_tooltip.text = button.description
		if button in [selected_torreta_button, selected_cadena_button]:
			button.modulate = Color.GREEN
		else:
			if button.is_hovered():
				button.modulate = Color.LIGHT_GREEN
			else:
				button.modulate = Color.WHITE
	var costo_total = selected_torreta_button.cost + selected_cadena_button.cost
	costo_total_label.text = "Costo total: [color=%s]%s[/color]" % [
		"red" if get_tree().get_first_node_in_group("level").oro < costo_total else "green",
		costo_total
	]
