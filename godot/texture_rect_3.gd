extends TextureRect

@export var noise: FastNoiseLite
var time: float = 0

func _process(delta: float) -> void:
	time+= delta

	rotation += delta * (remap(noise.get_noise_1d(time), -1.0, 1.0, -PI, PI)) / 12
