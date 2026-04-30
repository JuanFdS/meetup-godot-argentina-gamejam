extends PanelContainer

func _ready() -> void:
	mouse_entered.connect(func():
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		%DibujadorDeCadenas/Pointer.visible = false
	)
	mouse_exited.connect(func():
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		%DibujadorDeCadenas/Pointer.visible = true
	)
