extends Control

func _ready():
	$VBoxContainer/Start.grab_focus()


func _on_Start_pressed():
	get_tree().change_scene("res://Scenes/Main.tscn")

func _on_Options_pressed():
	pass # NYI


func _on_Exit_pressed():
	get_tree().quit()

