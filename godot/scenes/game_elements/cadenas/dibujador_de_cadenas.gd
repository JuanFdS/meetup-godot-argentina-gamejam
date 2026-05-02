class_name DibujadorDeCadenas
extends Node2D
@onready var marker: Sprite2D = $Pointer/Marker
const TORRETA = preload("uid://c0pme5p7ode1q")
const LASER_SPRITE = preload("uid://3x830hanhcvk")

enum State {
	Nothing,
	Drawing,
	DraggingExistingTurret
}

var state: State = State.Nothing
## Drawing
var line: Cadena
var torreta_1: Torreta
var torreta_2: Torreta
var laser_sprite: Sprite2D
var torreta_being_dragged: Torreta
var torreta_dragged_original_position: Vector2
var asteroide_from_torreta_being_dragged: Asteroide
@onready var label: RichTextLabel = $Pointer/Label
@onready var pointer: Node2D = $Pointer
@onready var detector_de_asteroide: Area2D = $Pointer/DetectorDeAsteroide

var unidad_actual

var hint_text: String
var pointer_color: Color
var showing_hint_text: bool = true

func exit_state():
	match state:
		State.Nothing:
			pass
		State.Drawing:
			if _can_place_torreta():
				get_parent().torreta_desplegada(unidad_actual)
				line.modulate = Color.WHITE
				_asteroide_bajo_el_cursor().agregar_torreta(torreta_2)
				laser_sprite.desplegar(line)
			else:
				line.queue_free()
				torreta_1.queue_free()
				torreta_2.queue_free()
				laser_sprite.queue_free()
			line = null
			torreta_1.process_mode = Node.PROCESS_MODE_INHERIT
			torreta_1 = null
			torreta_2.process_mode = Node.PROCESS_MODE_INHERIT
			torreta_2 = null
			laser_sprite = null
			for un_asteroide in get_tree().get_nodes_in_group("asteroide"):
				un_asteroide.modulate = Color.WHITE
		State.DraggingExistingTurret:
			var asteroide = _asteroide_bajo_el_cursor()
			if asteroide != null and asteroide.esta_libre():
				asteroide.agregar_torreta(torreta_being_dragged)
			elif asteroide:
				torreta_being_dragged.global_position = torreta_dragged_original_position
				asteroide_from_torreta_being_dragged.agregar_torreta(torreta_being_dragged)
				torreta_being_dragged.get_parent().get_children().filter(func(node): return node.is_in_group("laser")).front().visible = true
				update_line(torreta_being_dragged.get_parent())
			else:
				torreta_being_dragged.get_parent().queue_free()
			torreta_being_dragged = null
			torreta_dragged_original_position = Vector2.ZERO
			asteroide_from_torreta_being_dragged = null
			for un_asteroide in get_tree().get_nodes_in_group("asteroide"):
				un_asteroide.modulate = Color.WHITE

func enter_state():
	match state:
		State.DraggingExistingTurret:
			torreta_being_dragged = _torreta_bajo_el_cursor()
			asteroide_from_torreta_being_dragged = torreta_being_dragged.asteroide
			torreta_being_dragged.quitar_de_asteroide()
			torreta_dragged_original_position = torreta_being_dragged.global_position
			for asteroide in get_tree().get_nodes_in_group("asteroide"):
				if asteroide.esta_libre():
					asteroide.modulate = Color.CYAN
			
	match state:
		State.Nothing:
			pass
		State.Drawing:
			line = Cadena.new()
			line.unidad = unidad_actual
			line.default_color = Color.TRANSPARENT
			torreta_1 = unidad_actual.torreta_scene.instantiate()
			torreta_1.process_mode = Node.PROCESS_MODE_DISABLED
			_asteroide_bajo_el_cursor().agregar_torreta(torreta_1)
			torreta_2 = unidad_actual.torreta_scene.instantiate()
			torreta_2.process_mode = Node.PROCESS_MODE_DISABLED
			laser_sprite = unidad_actual.cadena_scene.instantiate()
			
			line.add_child(laser_sprite)
			line.add_child(torreta_1)
			line.add_child(torreta_2)
			torreta_1.global_position = get_global_mouse_position()
			torreta_2.global_position = get_global_mouse_position()
			line.add_point(torreta_1.position)
			line.add_point(torreta_2.position)
			add_child(line)
			for asteroide in get_tree().get_nodes_in_group("asteroide"):
				if asteroide.esta_libre():
					asteroide.modulate = Color.GREEN

func process_state():
	match state:
		State.Nothing:
			if _torreta_bajo_el_cursor():
				pointer_color = Color.CYAN
				hint_text = "Mantener Click
para mover la torreta"
			else:
				hint_text = "Mantener Click
para desplegar torretas
de un asteroide a otro"
				if _can_place_torreta():
					pointer_color = Color.GREEN
				else:
					pointer_color = Color.RED
		State.Drawing:
			hint_text = "Soltar Click
en otro asteroide
para confirmar"
			torreta_2.global_position = get_local_mouse_position()
			update_line(line)
			laser_sprite.visible = _can_place_torreta()
			line.modulate = Color.WHITE if _can_place_torreta() else Color.RED
			line.modulate.a = 1.0 if _can_place_torreta() else 0.5
			pointer_color = Color.GREEN if _can_place_torreta() else Color.RED
		
		State.DraggingExistingTurret:
			hint_text = "Soltar Click
en asteroide vacío"
			pointer_color = Color.CYAN if _can_move_torreta_here() else Color.RED
			var laser = torreta_being_dragged.get_parent().get_children().filter(func(node): return node.is_in_group("laser")).front()
			laser.visible = _can_move_torreta_here()
			torreta_being_dragged.global_position = get_global_mouse_position()
			update_line(torreta_being_dragged.get_parent())

func update_line(linea_con_cadena: Node):
	var torretas = linea_con_cadena.get_children().filter(func(torreta): return torreta.is_in_group("torreta"))
	var primera_torreta = torretas.front()
	var segunda_torreta = torretas.back()
	var point_a = primera_torreta.position
	var point_b = segunda_torreta.position
	linea_con_cadena.set_point_position(0, point_a)
	linea_con_cadena.set_point_position(1, point_b)
	var laser = linea_con_cadena.get_children().filter(func(un_laser): return un_laser.is_in_group("laser")).front()
	laser.position = (point_a + point_b) / 2
	laser.rotation = (point_a.direction_to(point_b)).angle()
	laser.width = point_a.distance_to(point_b)

func change_state(new_state):
	exit_state()
	state = new_state
	enter_state()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				if _torreta_bajo_el_cursor():
					change_state(State.DraggingExistingTurret)
				elif _can_place_torreta():
					change_state(State.Drawing)
			else:
				change_state(State.Nothing)
					

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _can_move_torreta_here() -> bool:
	var asteroide = _asteroide_bajo_el_cursor()
	return asteroide != null and asteroide.esta_libre()

func _can_place_torreta() -> bool:
	var asteroide = _asteroide_bajo_el_cursor()
	return asteroide != null and asteroide.esta_libre() and unidad_actual.costo_total() <= get_parent().oro

func _torreta_bajo_el_cursor() -> Torreta:
	return _elemento_bajo_el_cursor("torreta")

func _elemento_bajo_el_cursor(group):
	if detector_de_asteroide.has_overlapping_areas():
		var elementos = detector_de_asteroide.get_overlapping_areas().filter(func(area: Area2D): return area.duenio().is_in_group(group))
		if elementos.is_empty():
			return null
		return elementos.front().duenio()
	else:
		return null

func _asteroide_bajo_el_cursor() -> Asteroide:
	return _elemento_bajo_el_cursor("asteroide")

func _process(delta: float) -> void:
	var pointer_color_as_hex = pointer_color.to_html()
	label.text = "[color=%s]%s[/color]\n[font_size=14][i](H) para ocultar[/i][/font_size]" % [
		pointer_color_as_hex,
		hint_text
		]
	marker.rotation += delta
	pointer.global_position = get_global_mouse_position()
	marker.modulate = pointer_color
	process_state()
	label.visible = showing_hint_text
	if Input.is_action_just_pressed("toggle_showing_hint_text"):
		showing_hint_text = !showing_hint_text
