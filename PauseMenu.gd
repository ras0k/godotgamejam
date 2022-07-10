extends Control

var is_paused = false setget set_is_paused


func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		self.is_paused = !is_paused

func _on_Resume_pressed():
	self.is_paused = false


func _on_Exit_pressed():
	get_tree().quit()
