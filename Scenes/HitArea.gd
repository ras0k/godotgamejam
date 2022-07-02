extends Area2D

class_name HitArea

export var damage := 1

func _on_HitArea_area_entered(area: Area2D) -> void:
	if area is HurtArea:
		area.hurt(damage)


