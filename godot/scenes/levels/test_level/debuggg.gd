extends VBoxContainer

@onready var oro_x_enemigo: SpinBox = $HBoxContainer/OroXEnemigo
@onready var costo_x_torres: SpinBox = $HBoxContainer2/CostoXTorres
@onready var test_level: Level = $"../.."
@onready var oro_inicial: SpinBox = $HBoxContainer3/OroInicial
@onready var valor_venta_torre: SpinBox = $HBoxContainer4/ValorVentaTorre

func _process(delta: float) -> void:
	test_level.valor_oro_por_enemigo = oro_x_enemigo.value
	test_level.valor_costo_por_torre = costo_x_torres.value
	test_level.valor_venta_torre = valor_venta_torre.value
	if test_level.ola_actual == 0 and get_tree().get_nodes_in_group("torreta").is_empty():
		test_level.oro = oro_inicial.value
