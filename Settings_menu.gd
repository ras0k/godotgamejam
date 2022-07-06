extends Control

onready var _Display_option_btn = $CenterContainer/VBoxContainer/Label/CheckButton

func _ready():
	pass
	
func _physics_process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene("res://Menu.tscn")
	
func _on_CheckButton_toggled(button_pressed):
	GlobalSettings.toggle_fullscreen(button_pressed)



func _on_Back_pressed():
	get_tree().change_scene("res://Menu.tscn")
