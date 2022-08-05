extends Area2D


# Declare member variables here. Examples:
var a = 0.1
var s = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_select"):
		s = true
	if s == true:
		supernova()
	if abs((position - get_parent().get_parent().get_node("Spaceship").position).length()) > 99:
		if get_parent().get_parent().get_node("Spaceship").interstellar_fuel < 0.01:
			get_tree().reload_current_scene()
	pass



func supernova():
	if a < 1:
		a += 0.001
	$Sol2.scale += Vector2(1,1) * 0.0003
	$Sol2.modulate = Color(1.0,1.0,1.0,2*a)
	$SuperGiant.scale += Vector2(1,1) * 0.0004
	$SuperGiant.modulate = Color(1.0,1.0,1.0,a)
	
