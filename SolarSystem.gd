extends Node2D

onready var sun = $Sol
var asteroid := preload("res://Asteroid.tscn")

var rng := RandomNumberGenerator.new()


func _ready() -> void:
	rng.randomize()


func spawn_asteroid():
	var new_asteroid: RigidBody2D = asteroid.instance()
	add_child(new_asteroid)
	new_asteroid.position = Vector2(randi_range_pos_neg(40, 120), randi_range_pos_neg(40, 120))

	var sun_distance = new_asteroid.global_position - sun.global_position
	var normal = Vector2(-sun_distance.x, sun_distance.y)
	new_asteroid.linear_velocity = -normal / 10 # perpendicular to sun direction


func randi_range_pos_neg(from: int, to: int) -> int:
	return  positive_or_negative() * rng.randi_range(from, to)


func positive_or_negative() -> int:
	return [-1, 1][rng.randi_range(0, 1)]
