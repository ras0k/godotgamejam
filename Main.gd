extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()


func _on_Spaceship_turned(degrees: int) -> void:
	# 0 = up, rotate clockwise to 360
	# frames 0 to 16 from up clockwise
	var frame: int = (degrees + 11.25) / (360.0 / 16.0)
	printt(degrees, frame)
	$UI.rotate_compass(frame)
