extends RigidBody2D


var maxFuel:float = 2000.0
var fuel:float = 1200.0
var velocity = Vector2()
export var speed:int = 2
export var spin_thrust = 6
var shipAngle:int = 0
var rotation_dir = 0
var landed = false
var deathCounter = 0
var crashCounter = 0
export var flames_on = false
onready var compass = get_node("/root/Main/UI/compassSprite")

# Called when the node enters the scene tree for the first time.
func _ready():
	set_axis_velocity(Vector2(-6,4) * 0.8)
	turn_ship(120)
	pass # Replace with function body.

func _physics_process(delta):
	if Input.is_action_pressed("forward") and fuel > 0.0:
		velocity = speed * Vector2(cos(deg2rad(float(shipAngle)/160*360)),-sin(deg2rad(float(shipAngle)/160*360)))
		fuel = fuel - 0.8
		flames_on = true
#		$FlameSprite.visible = true
	else:
		velocity = Vector2()
		flames_on = false

		if fuel > maxFuel:
			fuel = maxFuel
	
	if Input.is_action_pressed("left") and fuel > 0.0:
		turn_ship(1)
		fuel = fuel - 0.25
	if Input.is_action_pressed("right") and fuel > 0.0:
		turn_ship(-1)
		fuel = fuel - 0.25
	
	applied_force = velocity
	rotation = 0
	
	if landed == true:
		fuel += 0.6
		$CPUParticles2D.emitting = false
	if landed == false and fuel < 1:
		deathCounter += 1
		if deathCounter > 360:
			get_tree().reload_current_scene()
	elif landed == false: 
		$CPUParticles2D.emitting = true
		deathCounter = 0
	if crashCounter > 0:
		$CPUParticles2D.emitting = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func turn_ship(a):
	shipAngle += a
	if shipAngle >= 160:
		shipAngle = 0
	if shipAngle < 0:
		shipAngle = 159
	match shipAngle:
		0:
			compass.frame = 4
		10:
			compass.frame = 3
		20:
			compass.frame = 2
		30:
			compass.frame = 1
		40:
			compass.frame = 0
		50:
			compass.frame = 15
		60:
			compass.frame = 14
		70:
			compass.frame = 13
		80:
			compass.frame = 12
		90:
			compass.frame = 11
		100:
			compass.frame = 10
		110:
			compass.frame = 9
		120:
			compass.frame = 8
		130:
			compass.frame = 7
		140:
			compass.frame = 6
		150:
			compass.frame = 5
