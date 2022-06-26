extends Node


func _ready():
	$VBoxContainer/BeginJourney.grab_focus()
	

func _on_BeginJourney_pressed():
	get_tree().change_scene("res://Scenes/StageOne.tscn")
