extends RigidBody2D


var velocity = Vector2.ZERO
var speed:int = 10
var shipAngle:int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if Input.is_action_pressed("forward"):
		velocity += 0.01 * speed * Vector2(cos(deg2rad(-shipAngle)),sin(deg2rad(-shipAngle)))
	if Input.is_action_pressed("left"):
		turn_ship(3)
	if Input.is_action_pressed("right"):
		turn_ship(-3)
	applied_force = velocity

# Called every frame. 'delta' is the elapsed time since the previous frame.
func turn_ship(a):
	shipAngle += a
	if shipAngle >= 360:
		shipAngle = 0
	if shipAngle < 0:
		shipAngle = 357
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