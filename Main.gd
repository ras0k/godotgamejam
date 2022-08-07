extends Node2D

onready var inventory_ui = $CanvasLayer/UI/Inventory

var asteroid := preload("res://Asteroid.tscn")
var asteroid_spawn_timer := 0

var run_time := 0.0
var invulnerable := true

var max_inventory_capacity := 5
var current_inventory := []

var pause_state = "running"
var prev_pause_state

func _ready() -> void:
	Engine.time_scale = 1
	for slot in max_inventory_capacity:
		add_resource(Global.resource_types.EMPTY)


func _process(delta: float) -> void:
	run_time += delta

	if Input.is_action_just_pressed("reset"):
		get_tree().paused = false
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("1"):
		Engine.time_scale = 1
	elif Input.is_action_just_pressed("2"):
		Engine.time_scale = 2
	elif Input.is_action_just_pressed("3"):
		Engine.time_scale = 4
	elif Input.is_action_just_pressed("4"):
		Engine.time_scale = 8
	
	if Input.is_action_just_pressed("pause"):
		if pause_state != "paused":
			prev_pause_state = pause_state
			pause_state = "paused"
		elif pause_state == "paused":
			pause_state = prev_pause_state
			prev_pause_state = "paused"
		print(pause_state)
		check_pause()

	asteroid_spawn_timer += 1
	if asteroid_spawn_timer % 160 == 1 and asteroid_spawn_timer < 2800:
		spawn_asteroid_belt(floor(rand_range(1,3)))


func _on_Spaceship_turned(degrees: int) -> void:
	# 0 = up, rotate clockwise to 360
	# frames 0 to 15 from up clockwise
	var sprite_frame_amount := 16
	var degree_fraction := 360.0 / float(sprite_frame_amount)
	var frame: int = (degrees + degree_fraction/2) / degree_fraction
	$CanvasLayer/UI.rotate_compass(frame % sprite_frame_amount)


func spawn_asteroid_belt(asteroid_count: int) -> void:
	for index in asteroid_count:
		$SolarSystem.add_child(asteroid.instance())


func is_inventory_ui_full() -> bool:
	return current_inventory.size() >= max_inventory_capacity


func add_resource(type: int) -> void:
	if not type == Global.resource_types.EMPTY:
		if current_inventory.has(Global.resource_types.EMPTY):
			current_inventory.erase(Global.resource_types.EMPTY)
		else:
			return # no free empty slot, don't do anything

	if not is_inventory_ui_full():
		current_inventory.append(type)
	current_inventory.sort_custom(self, 'sort_reverse')
	inventory_ui.update_inventory_ui(current_inventory)


func remove_resource(type: int) -> void:
	current_inventory.erase(type)
	if not is_inventory_ui_full():
		current_inventory.append(Global.resource_types.EMPTY)
	current_inventory.sort_custom(self, 'sort_reverse')
	inventory_ui.update_inventory_ui(current_inventory)


func sort_reverse(a: int, b: int) -> bool:
	return a > b # smaller numbers at the end


func check_pause():
	if pause_state == "running":
		get_tree().paused = false
	elif pause_state == "paused":
		get_tree().paused = true
		print("prev_pause_state : " + prev_pause_state)
		if prev_pause_state == "on_planet":
			get_node("CanvasLayer2").pause_mode = PAUSE_MODE_STOP
			print("no more process")
	elif pause_state == "on_planet":
		get_tree().paused = true
		print("prev_pause_state : " + prev_pause_state)
		if prev_pause_state == "paused":
			get_node("CanvasLayer2").pause_mode = PAUSE_MODE_PROCESS
			print("yes process")
