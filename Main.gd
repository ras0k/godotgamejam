extends Node2D

onready var inventory_ui = $CanvasLayer/UI/Inventory
onready var planet_scene = load("res://PlanetScene.tscn").instance()
onready var player = $Spaceship

var asteroid := preload("res://Asteroid.tscn")
var asteroid_spawn_timer := 0

var run_time := 0.0
var invulnerable := true

var max_inventory_capacity := 5
var current_inventory := []

var pause_state = "running"
var prev_pause_state = "running"
var stored_ship_velocity := Vector2.ZERO
var stored_solar_velocities := []
var touching_ground := false

func _ready() -> void:
	Engine.time_scale = 1
	for slot in max_inventory_capacity:
		add_resource(Global.resource_types.EMPTY)
	
	check_pause()


func _process(delta: float) -> void:
	run_time += delta
	
	if pause_state == "on_planet":
		planet_compass()
#		print(str($CanvasLayer2/PlanetScene/PlanetShip.position.x) + ", " + str($CanvasLayer2/PlanetScene/PlanetShip.position.y))
		if $CanvasLayer2/PlanetScene/PlanetShip.position.x < -64 or $CanvasLayer2/PlanetScene/PlanetShip.position.x > 128 or $CanvasLayer2/PlanetScene/PlanetShip.position.y < -5 or $CanvasLayer2/PlanetScene/PlanetShip.position.y > 64:
			pause_state = "running"
			player.fuel_multiplier = 1.0
			player.on_planet = false
			$CanvasLayer2.remove_child(planet_scene)
			get_node("Spaceship").mode = RigidBody2D.MODE_RIGID
			get_node("Spaceship").linear_velocity = stored_ship_velocity
			for child in get_node("SolarSystem").get_children():
				if child is RigidBody2D:
					child.linear_velocity = stored_solar_velocities.pop_front()
					child.mode = RigidBody2D.MODE_RIGID
			$CanvasLayer/UI/Compass.visible = true
			check_pause()
	
	
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
		else:
			pause_state = prev_pause_state
			prev_pause_state = "paused"
		print(pause_state)
		check_pause()
	
	
	if pause_state == "running":
		asteroid_spawn_timer += 1
		
	if asteroid_spawn_timer % 160 == 1 and asteroid_spawn_timer < 2800:
		spawn_asteroid_belt(floor(rand_range(1,3)))


func _on_Spaceship_turned(degrees: int) -> void:
	# 0 = up, rotate clockwise to 360
	# frames 0 to 15 from up clockwise
	if pause_state == "on_planet":
		return
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
		print("prev_pause_state : " + prev_pause_state)
#		if prev_pause_state == "on_planet":
#			get_node("CanvasLayer2").pause_mode = PAUSE_MODE_STOP
#			print("no more process")
		get_tree().paused = true
	elif pause_state == "on_planet":
		print("prev_pause_state : " + prev_pause_state)
		get_tree().paused = false
#		get_node("CanvasLayer2").pause_mode = Node.PAUSE_MODE_PROCESS
		
		print("yes process")
#		get_tree().paused = true
	print(pause_state)


func _on_Spaceship_landed_on_planet(landed):
	if landed:
		stored_ship_velocity = get_node("Spaceship").linear_velocity
		get_node("Spaceship").mode = RigidBody2D.MODE_STATIC
		for child in get_node("SolarSystem").get_children():
			if child is RigidBody2D:
				stored_solar_velocities.append(child.linear_velocity)
				child.mode = RigidBody2D.MODE_STATIC
		$CanvasLayer2.add_child(planet_scene)
		$CanvasLayer2/PlanetScene/PlanetShip.position = Vector2(24,-5)
		$CanvasLayer2/PlanetScene/PlanetShip.linear_velocity.y = 12
	else:
		get_node("Spaceship").mode = RigidBody2D.MODE_RIGID
		get_node("Spaceship").linear_velocity = stored_ship_velocity
		for child in get_node("SolarSystem").get_children():
			if child is RigidBody2D:
				child.linear_velocity = stored_solar_velocities.pop_front()
				child.mode = RigidBody2D.MODE_RIGID
		$CanvasLayer2.remove_child(planet_scene)
		player.fuel_multiplier = 1.0
		pause_state = "running"

func planet_compass():
	$CanvasLayer/UI/Compass.visible = false
	if touching_ground:
		$CanvasLayer/UI/Compass.frame = 0
#	$CanvasLayer/UI/Compass/Ship.frame = $CanvasLayer2/PlanetScene/PlanetShip/Ship.frame
#	$CanvasLayer/UI/Compass.frame = $CanvasLayer2/PlanetScene/PlanetShip/Ship.frame
