class_name DibujadorDeCadenas
extends Node2D
@onready var marker: Sprite2D = $Pointer/Marker
const TORRETA = preload("uid://c0pme5p7ode1q")
const LASER_SPRITE = preload("uid://3x830hanhcvk")

enum State {
	Nothing,
	Drawing
}

var state: State = State.Nothing
var line: Line2D
var torreta_1: Torreta
var torreta_2: Torreta
var laser_sprite: Sprite2D
@onready var label: Label = $Pointer/Label
@onready var pointer: Node2D = $Pointer
@onready var detector_de_asteroide: Area2D = $Pointer/DetectorDeAsteroide

func exit_state():
	match state:
		State.Nothing:
			label.text = "Soltar Click
para confirmar"
		State.Drawing:
			label.text = "Mantener Click
para desplegar torretas
encadenadas"
			if _can_place_torreta():
				var line_area := Area2D.new()
				var collision_shape := CollisionShape2D.new()
				line_area.add_child(collision_shape)
				var area_shape := RectangleShape2D.new()
				collision_shape.shape = area_shape
				var first_point := line.get_point_position(0)
				var last_point := line.get_point_position(1)
				var area_length := first_point.distance_to(last_point)
				var area_width := line.width
				line.add_child(line_area)
				line_area.position = (first_point + last_point) / 2.0
				line_area.rotation = first_point.direction_to(last_point).angle()
				line_area.collision_mask = 0
				line_area.collision_layer = 0
				line_area.set_collision_layer_value(4, true)
				area_shape.size = Vector2(area_length, area_width)
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

func enter_state():
	match state:
		State.Nothing:
			pass
		State.Drawing:
			line = Line2D.new()
			line.default_color = Color.TRANSPARENT
			torreta_1 = TORRETA.instantiate()
			torreta_1.process_mode = Node.PROCESS_MODE_DISABLED
			torreta_2 = TORRETA.instantiate()
			torreta_2.process_mode = Node.PROCESS_MODE_DISABLED
			laser_sprite = LASER_SPRITE.instantiate()
			
			line.add_child(laser_sprite)
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
			var point_a = line.get_point_position(0)
			var point_b = line.get_point_position(1)
			torreta_1.position = point_a
			torreta_2.position = point_b
			laser_sprite.position = (point_a + point_b) / 2
			laser_sprite.rotation = (point_a.direction_to(point_b)).angle()
			var laser_texture = laser_sprite.texture as GradientTexture2D
			laser_texture.width = max(1, point_a.distance_to(point_b))

func change_state(new_state):
	exit_state()
	state = new_state
	enter_state()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				if _can_place_torreta():
					change_state(State.Drawing)
			else:
				change_state(State.Nothing)
					

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _can_place_torreta() -> bool:
	return detector_de_asteroide.has_overlapping_areas() and \
		detector_de_asteroide.get_overlapping_areas().front().asteroide.esta_libre()

func _process(delta: float) -> void:
	marker.modulate = Color.GREEN if _can_place_torreta() else Color.RED
	marker.rotation += delta
	pointer.global_position = get_global_mouse_position()
	process_state()
