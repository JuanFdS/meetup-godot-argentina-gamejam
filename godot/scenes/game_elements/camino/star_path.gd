extends Node2D

@export var path: Path2D
@export_range(0.1, 1.0, 0.1) var star_scale: float
@export_range(0.1, 1.0, 0.1) var star_scale_random: float
@export_range(0.0, 100.0, 1.0, "suffix:px") var max_distance_from_path: float = 10.0
@export_range(0, 100, 1, "suffix:stars") var amount: int = 100

const STAR = preload("uid://chqxhafpwtmgq")
var stars: Dictionary[float, Star] = {}

func _ready() -> void:
	for i in range(0, amount):
		var offset_ratio = randf()
		var star = build_star(offset_ratio)
		stars[offset_ratio] = star
	var offsets = stars.keys()
	offsets.sort()
	var delay: float = 0
	for offset in offsets:
		delay += randf() * 2 / amount
		var star = stars[offset]
		get_tree().create_timer(delay).timeout.connect(func():
			path.add_child(star)
			var tween_time = randf() * 0.2
			create_tween().tween_property(star, "scale", star.scale, tween_time).from(Vector2.ZERO)
			create_tween().tween_property(star, "rotation", star.rotation, tween_time).from(0.0)
		)

func build_star(offset_ratio: float) -> Star:
	var sprite := Star.new()
	sprite.texture = STAR
	var curve := path.curve
	var star_position_with_direction := curve.sample_baked_with_rotation(offset_ratio * curve.get_baked_length())
	var star_position := star_position_with_direction.origin
	var star_direction := star_position_with_direction.x
	sprite.rotation = randf_range(0, PI * 2)
	sprite.modulate.a = randf_range(0.2, 0.6)
	sprite.scale = Vector2.ONE * (star_scale + randf_range(-star_scale_random, star_scale_random))
	sprite.position = star_position + randf_range(-max_distance_from_path, max_distance_from_path) * star_direction.rotated(PI/2)
	return sprite
