class_name DibujadorDeCadenas
extends Node2D
@onready var marker: Sprite2D = $Pointer/Marker
const TORRETA = preload("uid://c0pme5p7ode1q")

enum State {
	Nothing,
	Drawing
}

var state: State = State.Nothing
var line: Line2D
var torreta_1: Torreta
var torreta_2: Torreta
@onready var label: Label = $Pointer/Label
@onready var pointer: Node2D = $Pointer

func exit_state():
	match state:
		State.Nothing:
			label.text = "Soltar Click
para confirmar"
		State.Drawing:
			label.text = "Mantener Click
para desplegar torretas
encadenadas"
			line = null
			torreta_1 = null
			torreta_2 = null

func enter_state():
	match state:
		State.Nothing:
			pass
		State.Drawing:
			line = Line2D.new()
			torreta_1 = TORRETA.instantiate()
			torreta_2 = TORRETA.instantiate()
			line.add_child(torreta_1)
			line.add_child(torreta_2)
			line.add_point(get_local_mouse_position())
			line.add_point(get_local_mouse_position())
			add_child(line)

func process_state():
	match state:
		State.Nothing:
			pass
		State.Drawing:
			line.set_point_position(1, get_local_mouse_position())
			torreta_1.position = line.get_point_position(0)
			torreta_2.position = line.get_point_position(1)

func change_state(new_state):
	exit_state()
	state = new_state
	enter_state()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				change_state(State.Drawing)
			else:
				change_state(State.Nothing)

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _process(delta: float) -> void:
	marker.rotation += delta 
	pointer.global_position = get_global_mouse_position()
	process_state()
