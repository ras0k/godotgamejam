extends RigidBody2D

onready var trade_screen = load("res://planets/PlanetUI.tscn").instance()
onready var planet_scene = load("res://PlanetScene.tscn").instance()
onready var player_scene = load("res://ship/Spaceship.tscn").instance()
onready var main = get_parent()

export var speed := 10
export var initial_velocity := Vector2.ZERO

var flames_on := false
var space_speed = speed
# warning-ignore:integer_division
var planet_speed = speed / 2
var orbit_speed = speed * 3
var max_fuel := 4000.0
var fuel := 3600.0
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
var mining_rate := 0.36
var interstellar_fuel := 0.0
var mining_enabled := true
var current_planet
var on_planet := false
var planet_sprite
var current_import
var current_export
#var trading := false

var target_asteroid = null
var mined_resource_fraction := 0.0 setget set_mined_resource_fraction
var currently_mined_resource_type := 0

signal mining(mined_resource_fraction)
signal turned(degrees)
signal landed_on_planet(landed)


func _ready():
	$Laser.set_as_toplevel(true)
	linear_velocity = initial_velocity
	if not landed:
		current_planet = null
	turn_ship(0)


func _physics_process(_delta):
#	trade()
#	launch()

	if Input.is_action_pressed("forward") and fuel > 0.0 and Engine.time_scale == 1:
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

	elif not landed:
		$CPUParticles2D.emitting = true
		death_counter = 0
		speed = space_speed
	if crash_counter > 0:
		$CPUParticles2D.emitting = false

	if Input.is_action_just_pressed("mining_laser"):
		mining_enabled = not mining_enabled

	target_asteroid = get_closest_asteroid()

	$Laser.points = []
	if target_asteroid and mining_enabled and fuel > 100:
		$Laser.add_point(global_position)
		$Laser.add_point(target_asteroid.global_position)
		mine_resources()
	elif mined_resource_fraction <= 20 and mined_resource_fraction > 0:
		self.mined_resource_fraction -= 0.1


func set_mined_resource_fraction(fraction: float):
	mined_resource_fraction = fraction
	emit_signal('mining', mined_resource_fraction, currently_mined_resource_type)


func turn_ship(angle: int):
	ship_angle += angle
	if abs(ship_angle) >= 360:
		ship_angle = 0
	if ship_angle > 0:
		emit_signal('turned', ship_angle)
	else:
		emit_signal('turned', 360 + ship_angle)


func get_closest_asteroid():
	if $MiningArea.get_overlapping_bodies().empty():
		return null
	var closest = null
	var smallest_distance := 1000
	for asteroid in $MiningArea.get_overlapping_bodies():
		if asteroid.resource_type == Global.resource_types.EMPTY:
			continue
		var distance = asteroid.global_position.distance_to(global_position)
		if distance < smallest_distance:
			closest = asteroid
			smallest_distance = distance
	return closest


func mine_resources():
	if not target_asteroid.resource_type == currently_mined_resource_type:
		currently_mined_resource_type = target_asteroid.resource_type
		if currently_mined_resource_type == 1:
			self.mined_resource_fraction = get_parent().get_node("CanvasLayer/UI/MiningProgress").value
		elif currently_mined_resource_type == 2:
			self.mined_resource_fraction = get_parent().get_node("CanvasLayer/UI/BlueMiningProgress").value
		
	target_asteroid.remaining_ore -= mining_rate
	self.mined_resource_fraction += mining_rate
	if mined_resource_fraction >= 100:
		self.mined_resource_fraction = 0
