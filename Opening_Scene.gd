extends Node2D


func _ready():
	$AnimationPlayer.play("Opening_scene")
	yield(get_tree().create_timer(15),"timeout")
	get_tree().change_scene("res://Scenes/Main.tscn")
	
	
	
func _on_Button_pressed():
	get_tree().change_scene("res://Scenes/Main.tscn")
	
	

