extends StaticBody2D

export var is_healed := false


func _ready() -> void:
	$Particles2D.initialize($Corrupted.texture)
	if is_healed:
		$Corrupted.visible = false
	else:
		$Healed.visible = false


func heal() -> void:
	if is_healed:
		return
	$Particles2D.emitting = true
	var tw := Tween.new()
	add_child(tw)
	$Healed.self_modulate = Color.transparent
	$Healed.visible = true
	tw.interpolate_property($Corrupted, 'self_modulate', Color.white, Color.transparent, .5, Tween.TRANS_LINEAR)
	tw.interpolate_property($Healed, 'self_modulate', Color.transparent, Color.white, .5, Tween.TRANS_LINEAR)
	tw.start()
	yield(tw, 'tween_all_completed')
	$Corrupted.visible = false
