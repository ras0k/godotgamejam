extends Node2D

onready var sun = $Sol
var asteroid := preload("res://Asteroid.tscn")
var inner_spawn_radius = 120
var outer_spawn_radius = 150

var rng := RandomNumberGenerator.new()


func _ready() -> void:
	rng.randomize()


func spawn_asteroid():
	var new_asteroid: RigidBody2D = asteroid.instance()
	add_child(new_asteroid)
	new_asteroid.position = Vector2(rand_range(-outer_spawn_radius, outer_spawn_radius), rand_range(-outer_spawn_radius, outer_spawn_radius))
	while new_asteroid.position.length() < inner_spawn_radius:
		new_asteroid.position = Vector2(rand_range(-outer_spawn_radius, outer_spawn_radius), rand_range(-outer_spawn_radius, outer_spawn_radius))
	
	var sun_distance = new_asteroid.global_position - sun.global_position
	var normal = Vector2(sun_distance.y, -sun_distance.x) 
	new_asteroid.linear_velocity = normal / 10 # perpendicular to sun direction


func randi_range_pos_neg(from: int, to: int) -> int:
	return  positive_or_negative() * rng.randi_range(from, to)


func positive_or_negative() -> int:
	return [-1, 1][rng.randi_range(0, 1)]
