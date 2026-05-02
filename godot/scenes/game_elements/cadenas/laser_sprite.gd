class_name LaserSprite
extends Sprite2D

var line_area: Area2D

var width: float :
	set(new_width):
		width = new_width
		var laser_texture = texture as GradientTexture2D
		laser_texture.width = max(1, width)

func desplegar(line: Line2D):
	line_area = Area2D.new()
	line_area.add_to_group("fuego_laser")
	var collision_shape := CollisionShape2D.new()
	line_area.add_child(collision_shape)
	var area_shape := RectangleShape2D.new()
	collision_shape.shape = area_shape
	var first_point := line.get_point_position(0)
	var last_point := line.get_point_position(1)
	var area_length := first_point.distance_to(last_point)
	var area_width := line.width * 2.0
	line.add_child(line_area)
	line_area.position = (first_point + last_point) / 2.0
	line_area.rotation = first_point.direction_to(last_point).angle()
	line_area.collision_mask = 0
	line_area.collision_layer = 0
	line_area.set_collision_layer_value(4, true)
	line_area.set_collision_mask_value(2, true)
	area_shape.size = Vector2(area_length, area_width)

func _process(delta: float) -> void:
	if line_area:
		$AudioStreamPlayer2D.playing = line_area.has_overlapping_areas()
