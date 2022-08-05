extends Node2D

var asteroid = preload("res://Asteroid.tscn")
var asteroid_spawn_timer := 0

var run_time := 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	run_time += delta
	
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	if Input.is_action_pressed("speeeeed"):
		Engine.time_scale = 3
	else:
		Engine.time_scale = 1
	
	asteroid_spawn_timer += 1
	if asteroid_spawn_timer % 180 == 1 and asteroid_spawn_timer < 2800:
		spawn_asteroid_belt(floor(rand_range(1,3)))


func _on_Spaceship_turned(degrees: int) -> void:
	# 0 = up, rotate clockwise to 360
	# frames 0 to 15 from up clockwise
	var sprite_frame_amount := 16
	var degree_fraction := 360.0 / float(sprite_frame_amount)
	var frame: int = (degrees + degree_fraction/2) / degree_fraction
	$UI.rotate_compass(frame % sprite_frame_amount)

func spawn_asteroid_belt(n):
	for i in n:
		$SolarSystem.add_child(asteroid.instance())
		
