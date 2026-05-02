@tool
extends Sprite2D

const radio_ventilador: float = 25.0
const MINA_INDIVIDUAL = preload("uid://cg8hxsxc8cq0m")

@export var width: float :
	set(new_width):
		width = new_width
		var diametro_mina = radio_ventilador * 2
		var cantidad_minas = roundi(width / diametro_mina)
		for i in range(0, get_child_count()):
			var mina = get_child(i)
			mina.visible = i < cantidad_minas
			mina.position.x = ((i + 0.5) * diametro_mina) - width / 2

func desplegar(line: Line2D):
	var line_area := Area2D.new()
	line_area.add_to_group("ventilador")
	var collision_shape := CollisionShape2D.new()
	line_area.add_child(collision_shape)
	var area_shape := RectangleShape2D.new()
	collision_shape.shape = area_shape
	var first_point := line.get_point_position(0)
	var last_point := line.get_point_position(1)
	var area_length := first_point.distance_to(last_point)
	var area_width := radio_ventilador * 3.0
	line.add_child(line_area)
	line_area.position = (first_point + last_point) / 2.0
	line_area.rotation = first_point.direction_to(last_point).angle()
	line_area.collision_mask = 0
	line_area.collision_layer = 0
	line_area.set_collision_layer_value(4, true)
	area_shape.size = Vector2(area_length, area_width)
