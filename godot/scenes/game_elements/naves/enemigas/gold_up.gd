extends Label

var started = false

func start(oro):
	started = true
	text = "+$%s" % oro

func _process(delta: float) -> void:
	visible = started
	if started:
		position.y -= delta * 10.0
		modulate.a -= delta
	if modulate.a <= 0.0:
		queue_free()
	
