extends KinematicBody2D

const Max_Fuel = 100.0

export var fuel_level = 20.0

var velocity = Vector2.ZERO
var speed:int = 0
var shipAngle:int = 0


func _ready():
	pass

func _physics_process(delta):
	if Input.is_action_pressed("forward"):
		velocity.y = velocity.y - 1.0
	if Input.is_action_just_pressed("break"):
		velocity.y = velocity.y + 1.0
	if Input.is_action_just_pressed("left"):
		turn_ship(30)
	if Input.is_action_just_pressed("right"):
		turn_ship(-30)
	velocity = move_and_slide(velocity)
	
	debug_info()


func attract_to(pos, force):
	var dist = global_position.distance_to(pos)
	var v = global_position.direction_to(pos) * force
	v = v.clamped(dist)
#	print("Affected by Gravity Well!")
	velocity += v

func turn_ship(a):
	shipAngle += a
	if shipAngle >= 360:
		shipAngle = 0
	if shipAngle < 0:
		shipAngle = 330
	match shipAngle:
		0:
			$ShipSprite.frame = 3
		30:
			$ShipSprite.frame = 2
		60:
			$ShipSprite.frame = 1
		90:
			$ShipSprite.frame = 0
		120:
			$ShipSprite.frame = 1
		150:
			$ShipSprite.frame = 2
		180:
			$ShipSprite.frame = 3
		210:
			$ShipSprite.frame = 2
		240:
			$ShipSprite.frame = 1
		270:
			$ShipSprite.frame = 0
		300:
			$ShipSprite.frame = 1
		330:
			$ShipSprite.frame = 2
	if shipAngle > 180:
		get_node( "ShipSprite" ).set_flip_v(true)
	else:
		get_node( "ShipSprite" ).set_flip_v(false)
	if shipAngle < 270 && shipAngle > 90:
		get_node( "ShipSprite" ).set_flip_h(true)
	else:
		get_node( "ShipSprite" ).set_flip_h(false)
	




func debug_info():
	if Input.is_action_just_pressed("ui_focus_next"):
		print("***SHIP START DEBUG INFO***")
		print("Velocity X value: " + str(velocity.x))
		print("Velocity Y value: " + str(velocity.y))
		print("***SHIP END DEBUG INFO***")
		print("")
