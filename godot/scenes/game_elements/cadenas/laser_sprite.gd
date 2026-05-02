class_name LaserSprite
extends Sprite2D

var width: float :
	set(new_width):
		width = new_width
		var laser_texture = texture as GradientTexture2D
		laser_texture.width = max(1, width)

func desplegar():
	pass
