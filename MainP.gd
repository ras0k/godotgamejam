extends Node2D

# this is a modified version of Main.gd for the StartMenu background

var asteroid = preload("res://Asteroid.tscn")
var asteroid_spawn_timer := 0

var run_time := 0.0

func _process(delta):
	run_time += delta
	Engine.time_scale = 3


	
	asteroid_spawn_timer += 1
	if asteroid_spawn_timer % 160 == 1 and asteroid_spawn_timer < 2800:
		spawn_asteroid_belt(floor(rand_range(1,3)))

func spawn_asteroid_belt(n):
	for i in n:
		$SolarSystem.add_child(asteroid.instance())
