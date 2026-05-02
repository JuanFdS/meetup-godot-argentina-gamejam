extends PanelContainer

func _ready() -> void:
	mouse_entered.connect(func():
		%DibujadorDeCadenas/Pointer.visible = false
	)
	mouse_exited.connect(func():
		%DibujadorDeCadenas/Pointer.visible = true
	)
