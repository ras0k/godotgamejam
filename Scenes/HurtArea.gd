extends Area2D

class_name HurtArea

signal hurt(damage)


func hurt(damage: int) -> void:
	print('hurt!')
	emit_signal('hurt', damage)
