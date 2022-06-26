extends Node

func _ready():
	$VBoxContainer/Exit.grab_focus()
	

func _on_Exit_pressed():
	get_tree().change_scene("res://Scenes/TitleScreen.tscn")
