extends RigidBody2D

onready var trade_screen = load("res://planets/PlanetUI.tscn").instance()
onready var planet_scene = load("res://PlanetScene.tscn").instance()
onready var player_scene = load("res://ship/Spaceship.tscn").instance()
onready var main = get_parent()

export var speed := 8

var flames_on := false
var space_speed = speed
var planet_speed = speed / 2
var orbit_speed = speed * 3
var max_fuel := 2000.0
var fuel := 1600.0
var fuel_multiplier := 1.0
var planet_fuel_multiplier := 0.42
var velocity = Vector2()
var ship_angle := 0
var rotation_dir := 0
var landed := false
var death_counter := 0
var crash_counter := 0
var boost := 1.0
var max_boost := 2.4
var is_mining := false
var mining_rate := 0.36
var ore_count := 0.0
var mining_targets := 0
var interstellar_fuel := 0.0
var laser_toggle := true
var current_planet
var on_planet := false
var planet_sprite
var current_import
var current_export
#var trading := false


signal turned(degrees)
signal landed_on_planet(landed)


func _ready():
	if not landed:
		current_planet = null
	turn_ship(0)
	pass # Replace with function body.


func _physics_process(_delta):
#	trade()
#	launch()
	if Input.is_action_pressed("forward") and fuel > 0.0:
		velocity = speed * Vector2(-cos(deg2rad(ship_angle + 90)), -sin(deg2rad(ship_angle + 90)))
		fuel -= fuel_multiplier * 0.8
		flames_on = true
		boost = 1.0
		$Thrusters.volume_db = -8
		$Thrusters.pitch_scale = 0.8
		$Thrusters.stream_paused = false
		if Input.is_action_pressed("boost") and fuel > 0.0:
			boost = max_boost
			fuel -= max_boost * 0.8 * fuel_multiplier
			$Thrusters.volume_db = -2
			$Thrusters.pitch_scale = 0.9
	else:
		velocity = Vector2()
		flames_on = false
		$Thrusters.stream_paused = true

	if fuel > max_fuel:
		fuel = max_fuel

	if Input.is_action_pressed("left") and fuel > 0.0:
		turn_ship(-2)
		fuel -= fuel_multiplier * 0.25
	if Input.is_action_pressed("right") and fuel > 0.0:
		turn_ship(2)
		fuel -= fuel_multiplier * 0.25

	applied_force = velocity * boost
	rotation = 0
	
	if landed == true:
#		fuel += 2
		speed = orbit_speed
		$CPUParticles2D.emitting = false
#		if Input.is_action_pressed("boost") and fuel > 0.0:
#			fuel += 3
		if Input.is_action_just_pressed("ui_select"):
			if on_planet:
#				on_planet = false
#				fuel_multiplier = 1.0
#				main.pause_state = "running"
#				emit_signal("landed_on_planet", false)
			
				print("you are leaving the planet")
#				get_parent().get_child(0).remove_child(planet_scene)
			elif not on_planet:
				on_planet = true
				fuel_multiplier = planet_fuel_multiplier
				emit_signal("landed_on_planet", true)
#				get_parent().get_child(0).add_child(planet_scene)
				main.pause_state = "on_planet"
				print("you are going on the planet")
				print(main.pause_state)


	elif not landed:
		$CPUParticles2D.emitting = true
		death_counter = 0
		speed = space_speed
	if crash_counter > 0:
		$CPUParticles2D.emitting = false

	if Input.is_action_just_pressed("mining_laser"):
		laser_toggle = not laser_toggle

	if fuel < 50:
		laser_toggle = false

	if is_mining and laser_toggle:
		mining()



func turn_ship(angle: int):
	ship_angle += angle
	if abs(ship_angle) >= 360:
		ship_angle = 0
	if ship_angle > 0:
		emit_signal('turned', ship_angle)
	else:
		emit_signal('turned', 360 + ship_angle)



func _on_MiningArea_body_entered(body):
	if "Asteroid" in body.name:
		is_mining = true
		mining_targets += 1


func _on_MiningArea_body_exited(body):
	if "Asteroid" in body.name:
		mining_targets -= 1
		if mining_targets < 1:
			is_mining = false

func mining():
	return


	for body in $MiningArea.get_overlapping_bodies():
		if body.resource_type == "white":
				Global.white_resource_amount += mining_rate * 0.2
		elif body.resource_type == "blue":
				Global.blue_resource_amount += mining_rate * 0.37
		elif body.resource_type == "green":
				Global.green_resource_amount += mining_rate * 0.5
		elif body.resource_type == "red":
				Global.red_resource_amount += mining_rate * 0.6
#		elif body.resource_type == "black":
#				black_resource_amount += mining_rate
		body.remaining_ore -= mining_rate
#		print("white: " + str(white_resource_amount))
#		print("blue: " + str(blue_resource_amount))
#		print("green: " + str(green_resource_amount))
#		print("red: " + str(red_resource_amount))
#		print("black: " + str(black_resource_amount))
#		fuel -= fuel_multiplier * 0.3
#
#func launch():
#	if landed and Input.is_action_just_pressed("launch"):
#		$LaunchTimer.start(5.0)
#		speed *= 5
#		landed = false
#		set_collision_layer_bit(1, false)
#		set_collision_mask_bit(2, false)
#		set_collision_mask_bit(3, false)
#		set_collision_mask_bit(4, false)
#		print("Launch Started!")
#
#
#func _on_LaunchTimer_timeout():
#	speed = 8
#	set_collision_layer_bit(1, true)
#	set_collision_mask_bit(2, true)
#	set_collision_mask_bit(3, true)
#	set_collision_mask_bit(4, true)
#	print("Launch Ended!")

#func trade():
#	if landed and Input.is_action_just_pressed("interact"):
#		current_import = current_planet.import_good
#		current_export = current_planet.export_good
#		self.add_child(trade_screen)
#		trading = true
#		get_tree().paused = true
##		print("trading")
