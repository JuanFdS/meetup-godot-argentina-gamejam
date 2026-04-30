extends Area2D

func hit_base():
	get_parent().hit_base()

func hit_by_disparo(disparo):
	get_parent().hit_by_disparo(disparo)
