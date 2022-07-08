extends Area2D

var is_enabled := false setget set_is_enabled
var is_open := false setget set_is_open


func set_is_enabled(_is_enabled: bool) -> void:
	is_enabled = _is_enabled
	visible = is_enabled
	monitorable = is_enabled


func set_is_open(_is_open: bool) -> void:
	is_open = _is_open
	monitoring = is_open
	if is_open:
		$SpriteOpen.visible = true
		$SpriteClosed.visible = false
	else:
		$SpriteOpen.visible = false
		$SpriteClosed.visible = true
