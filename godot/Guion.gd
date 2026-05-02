extends Node

func dialogo_post_ola_1_entran_asteroides():
	await get_tree().get_first_node_in_group("level").entrar_asteroides_para_ola_2()

func habilitar_nueva_torreta_y_cadenas():
	await get_tree().get_first_node_in_group("level").habilitar_nueva_torreta_y_cadenas()

func habilitar_segundo_camino():
	await get_tree().get_first_node_in_group("level").habilitar_segundo_camino()

func habilitar_primera_cadena():
	await get_tree().get_first_node_in_group("level").habilitar_primera_cadena_nueva()
