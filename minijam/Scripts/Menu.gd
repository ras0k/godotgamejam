extends Node

func _ready():
	$VBoxContainer/Start.grab_focus()
func _on_Start_pressed():
	get_tree().change_scene("res://Scenes/StageOne.tscn")


func _on_Exit_pressed():
	get_tree().quit()
