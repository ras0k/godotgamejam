extends RigidBody2D

export var speed := 8
export var spin_thrust := 6
export var initial_velocity := Vector2.ZERO

var max_fuel := 2000.0
var fuel := 1200.0
var velocity = Vector2()
var ship_angle := 0
var rotation_dir := 0
var landed := false
var death_counter := 0
var crash_counter := 0
export var flames_on := false

signal turned(degrees)


func _ready():
	set_axis_velocity(initial_velocity)
	turn_ship(180)
	pass # Replace with function body.


func _physics_process(_delta):
	if Input.is_action_pressed("forward") and fuel > 0.0:
		velocity = speed * Vector2(-cos(deg2rad(ship_angle + 90)), -sin(deg2rad(ship_angle + 90)))
		fuel = fuel - 0.8
		flames_on = true
#		$FlameSprite.visible = true
	else:
		velocity = Vector2()
		flames_on = false

		if fuel > max_fuel:
			fuel = max_fuel

	if Input.is_action_pressed("left") and fuel > 0.0:
		turn_ship(-1)
		fuel = fuel - 0.25
	if Input.is_action_pressed("right") and fuel > 0.0:
		turn_ship(1)
		fuel = fuel - 0.25

	applied_force = velocity
	rotation = 0

	if landed == true:
		fuel += 0.6
		$CPUParticles2D.emitting = false
	if landed == false and fuel < 1:
		death_counter += 1
		if death_counter > 360:
			get_tree().reload_current_scene()
	elif landed == false:
		$CPUParticles2D.emitting = true
		death_counter = 0
	if crash_counter > 0:
		$CPUParticles2D.emitting = false


func turn_ship(angle: int):
	ship_angle += angle
	if abs(ship_angle) >= 360:
		ship_angle = 0
	if ship_angle > 0:
		emit_signal('turned', ship_angle)
	else:
		emit_signal('turned', 360 + ship_angle)

