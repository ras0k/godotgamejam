extends KinematicBody2D

const Max_Fuel = 100.0

export var fuel_level = 20.0

var velocity = Vector2.ZERO


func _ready():
	pass

func _physics_process(delta):
	if Input.is_action_just_pressed("forward"):
		velocity.y = velocity.y - 1.0
	if Input.is_action_just_pressed("break"):
		velocity.y = velocity.y + 1.0
	if Input.is_action_just_pressed("left"):
		velocity.x = velocity.x - 1.0
	if Input.is_action_just_pressed("right"):
		velocity.x = velocity.x + 1.0
	velocity = move_and_slide(velocity)
	debug_info()


func attract_to(pos, force):
	var dist = global_position.distance_to(pos)
	var v = global_position.direction_to(pos) * force
	v = v.clamped(dist)
#	print("Affected by Gravity Well!")
	velocity += v







func debug_info():
	if Input.is_action_just_pressed("ui_focus_next"):
		print("***SHIP START DEBUG INFO***")
		print("Velocity X value: " + str(velocity.x))
		print("Velocity Y value: " + str(velocity.y))
		print("***SHIP END DEBUG INFO***")
		print("")
