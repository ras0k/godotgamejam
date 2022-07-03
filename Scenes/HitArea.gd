extends Area2D

class_name HitArea

export var damage := 1
export var enabled := false setget set_enabled

func _on_HitArea_area_entered(area: Area2D) -> void:
	if area is HurtArea:
		area.hurt(damage)


func set_enabled(is_enabled: bool) -> void:
	enabled = is_enabled
	monitoring = is_enabled
	monitorable = is_enabled
	modulate = Color.darkblue if is_enabled else Color.white
