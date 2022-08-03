extends RigidBody2D


var maxFuel:float = 1000.0
var fuel:float = 500
var velocity = Vector2()
export var speed:int = 4
export var spin_thrust = 6
var shipAngle:int = 0
var rotation_dir = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_axis_velocity(Vector2(0,-8))
	pass # Replace with function body.

func _physics_process(delta):
	if Input.is_action_pressed("forward") and fuel > 0.0:
		velocity = -speed * transform.y
		fuel = fuel - 1.0
		$FlameSprite.visible = true
	else:
		velocity = Vector2()
		$FlameSprite.visible = false
		
	rotation_dir = 0
	if Input.is_action_pressed("right") and fuel > 0.0:
		rotation_dir += 1
		fuel -= 0.3
	if Input.is_action_pressed("left") and fuel > 0.0:
		rotation_dir -= 1
		fuel -= 0.3
	
#	if Input.is_action_pressed("left") and fuel > 0.0:
#		turn_ship(3)
#		fuel = fuel - 0.5
#	if Input.is_action_pressed("right") and fuel > 0.0:
#		turn_ship(-3)
#		fuel = fuel - 0.5
	
	applied_force = velocity
	applied_torque = rotation_dir * spin_thrust
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func turn_ship(a):
#	shipAngle += a
#	if shipAngle >= 360:
#		shipAngle = 0
#	if shipAngle < 0:
#		shipAngle = 357
#	match shipAngle:
#		0:
#			$ShipSprite.frame = 3
#		30:
#			$ShipSprite.frame = 2
#		60:
#			$ShipSprite.frame = 1
#		90:
#			$ShipSprite.frame = 0
#		120:
#			$ShipSprite.frame = 1
#		150:
#			$ShipSprite.frame = 2
#		180:
#			$ShipSprite.frame = 3
#		210:
#			$ShipSprite.frame = 2
#		240:
#			$ShipSprite.frame = 1
#		270:
#			$ShipSprite.frame = 0
#		300:
#			$ShipSprite.frame = 1
#		330:
#			$ShipSprite.frame = 2
#	if shipAngle > 180:
#		get_node( "ShipSprite" ).set_flip_v(true)
#	else:
#		get_node( "ShipSprite" ).set_flip_v(false)
#	if shipAngle < 270 && shipAngle > 90:
#		get_node( "ShipSprite" ).set_flip_h(true)
#	else:
#		get_node( "ShipSprite" ).set_flip_h(false)
