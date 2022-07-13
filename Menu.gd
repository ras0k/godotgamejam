extends Control


onready var _Settings_Menu = $Settings_Menu

func _ready():
	$VBoxContainer/Start.grab_focus()

func _on_Start_pressed():
	get_tree().change_scene("res://Scenes/Main.tscn")

func _on_Options_pressed():
	_Settings_Menu.popup_centered()


func _on_Exit_pressed():
	get_tree().quit()



func _on_Button_pressed():
	get_tree().change_scene("res://OpeningScene.tscn")
