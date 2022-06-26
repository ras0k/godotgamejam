extends Node

func _ready():
	$VBoxContainer/Start.grab_focus()
func _on_Start_pressed():
	get_tree().change_scene("res://Scenes/Intro.tscn")


func _on_Exit_pressed():
	get_tree().quit()


func _on_About_pressed():
	get_tree().change_scene("res://Scenes/About.tscn")
