extends Control
@onready var label: Label = $Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var play_again_button: Button = %PlayAgainButton

func win():
	play_animation_with_text("Ganaste")

func lose():
	play_animation_with_text("Perdiste")


func play_animation_with_text(text: String):
	visible = true
	label.text = text
	animation_player.play("popup")
	await animation_player.animation_finished
	play_again_button.grab_focus()
