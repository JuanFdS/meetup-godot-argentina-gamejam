class_name Music
extends Node

@export_range(0.0, 5.0, 0.05, "suffix:s") var fade_time_in_seconds: float = 2.5
@onready var level_music: AudioStreamPlayer = $LevelMusic

func _ready():
	for stream_idx in level_music.stream.stream_count:
		level_music.stream.set_sync_stream_volume(stream_idx, linear_to_db(0))
	play(Level.Mode.Planning)
	

func stop():
	level_music.stop()

func play(mode: Level.Mode):
	match mode:
		Level.Mode.Planning:
			fade_into(1, 0, fade_time_in_seconds)
		Level.Mode.Battling:
			fade_into(0, 1, fade_time_in_seconds)
	if not level_music.playing:
		level_music.play()

func play_boss_music():
	fade_into(1, 2, 1.5)

func fade_into(previous_sync_stream_idx: int, next_sync_stream_idx: int, duration_in_seconds: float):
	var stream: AudioStreamSynchronized = level_music.stream as AudioStreamSynchronized
	create_tween().tween_method(func(value):
		stream.set_sync_stream_volume(
			previous_sync_stream_idx,
			min(stream.get_sync_stream_volume(previous_sync_stream_idx), linear_to_db(1 - value))
		)
		stream.set_sync_stream_volume(
			next_sync_stream_idx,
			max(stream.get_sync_stream_volume(next_sync_stream_idx), linear_to_db(value))
		),
		0.0, 1.0,
		duration_in_seconds
	).set_ease(Tween.EASE_OUT)
