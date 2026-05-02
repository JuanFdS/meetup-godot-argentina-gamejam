@tool
extends Sprite2D

const radio_mina: float = 25.0
const MINA_INDIVIDUAL = preload("uid://cg8hxsxc8cq0m")

@export var width: float :
	set(new_width):
		width = new_width
		var diametro_mina = radio_mina * 2
		var cantidad_minas = roundi(width / diametro_mina)
		for i in range(0, get_child_count()):
			var mina = get_child(i)
			mina.visible = i < cantidad_minas
			mina.position.x = ((i + 0.5) * diametro_mina) - width / 2

func desplegar():
	for child in get_children():
		if child.visible:
			var mina = MINA_INDIVIDUAL.instantiate()
			var mina_position = child.global_position
			child.replace_by(mina)
			mina.global_position = mina_position
			child.queue_free()
		else:
			child.queue_free()
