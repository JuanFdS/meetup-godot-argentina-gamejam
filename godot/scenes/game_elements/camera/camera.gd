extends Camera2D

@export var noise: FastNoiseLite
@export var max_shake_intensity: float = 10.0
@export var shake_attenuation: float = 5.0
@export var shake_frequency: float = 5.0
var time: float = 0.0
var shake_intensity: float = 0.0

func _ready():
	noise.seed = randi()

func _process(delta: float) -> void:
	time += delta
	shake_intensity = move_toward(shake_intensity, 0.0, shake_attenuation * delta)

	var noise_x = noise.get_noise_1d(time * shake_frequency)
	var noise_y = noise.get_noise_1d(time * shake_frequency + 200)
	offset.x = shake_intensity * noise_x
	offset.y = shake_intensity * noise_y

func add_shake(value = max_shake_intensity):
	shake_intensity = min(shake_intensity + value, max_shake_intensity)
