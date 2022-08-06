extends RigidBody2D

export var speed := 8
export var spin_thrust := 6
export var initial_velocity := Vector2(-4,8)
export var flames_on := false

var max_fuel := 2000.0
var fuel := 1600.0
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
var white_resource_amount := 0.0
var blue_resource_amount := 0.0
var green_resource_amount := 0.0
var red_resource_amount := 0
var black_resource_amount := 0.0



signal turned(degrees)


func _ready():
	set_axis_velocity(initial_velocity)
	turn_ship(180)
	pass # Replace with function body.


func _physics_process(_delta):
	launch()
	if Input.is_action_pressed("forward") and fuel > 0.0:
		velocity = speed * Vector2(-cos(deg2rad(ship_angle + 90)), -sin(deg2rad(ship_angle + 90)))
		fuel -= 0.8
		flames_on = true
		boost = 1.0
		if Input.is_action_pressed("boost") and fuel > 0.0:
			boost = max_boost
			fuel -= max_boost * 0.8
	else:
		velocity = Vector2()
		flames_on = false

	if fuel > max_fuel:
		fuel = max_fuel

	if Input.is_action_pressed("left") and fuel > 0.0:
		turn_ship(-2)
		fuel -= 0.25
	if Input.is_action_pressed("right") and fuel > 0.0:
		turn_ship(2)
		fuel -= 0.25

	applied_force = velocity * boost
	rotation = 0

	if landed == true:
		fuel += 0.8
		$CPUParticles2D.emitting = false
		if Input.is_action_pressed("boost") and fuel > 0.0:
			fuel += 1.8
#	if not landed and fuel < 1:
#		death_counter += 1
#		if death_counter > 500:
#			get_tree().reload_current_scene()
	elif not landed:
		$CPUParticles2D.emitting = true
		death_counter = 0
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
	for body in $MiningArea.get_overlapping_bodies():
		if body.resource_type == "white":
				white_resource_amount += mining_rate * 0.2
		elif body.resource_type == "blue":
				blue_resource_amount += mining_rate * 0.37
		elif body.resource_type == "green":
				green_resource_amount += mining_rate * 0.5
		elif body.resource_type == "red":
				red_resource_amount += mining_rate * 0.6
		elif body.resource_type == "black":
				black_resource_amount += mining_rate
		body.remaining_ore -= mining_rate
#		print("white: " + str(white_resource_amount))
#		print("blue: " + str(blue_resource_amount))
#		print("green: " + str(green_resource_amount))
#		print("red: " + str(red_resource_amount))
#		print("black: " + str(black_resource_amount))
		fuel -= 0.3

func launch():
	if landed == true and Input.is_action_just_pressed("launch"):
		$LaunchTimer.start(5.0)
		speed *= 5
		landed = false
		set_collision_layer_bit(1, false)
		set_collision_mask_bit(2, false)
		set_collision_mask_bit(3, false)
		set_collision_mask_bit(4, false)
		print("Launch Started!")


func _on_LaunchTimer_timeout():
	speed = 8
	set_collision_layer_bit(1, true)
	set_collision_mask_bit(2, true)
	set_collision_mask_bit(3, true)
	set_collision_mask_bit(4, true)
	print("Launch Ended!")
