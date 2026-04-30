extends Button

const TORRETA = preload("uid://c0pme5p7ode1q")

func _ready():
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func _pressed() -> void:
	spawn_torreta()
	queue_free()

func spawn_torreta():
	var torreta = TORRETA.instantiate()
	get_parent().get_parent().add_child(torreta)
	torreta.global_position = get_global_transform() * get_rect().end
	
