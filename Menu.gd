extends Control

func _ready():
	$VBoxContainer/Start.grab_focus()
	$AnimationPlayer.play("Opening_Scene")
	yield(get_tree().create_timer(2.9),"timeout")
	$ColorRect.visible = false;

func _on_Start_pressed():
	get_tree().change_scene("res://Scenes/Main.tscn")

func _on_Options_pressed():
	pass # NYI


func _on_Exit_pressed():
	get_tree().quit()
	
	
