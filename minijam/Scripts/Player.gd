extends KinematicBody2D

var speed : int = 400
var jump_speed : int = -200
var gravity : int = 200
var velocity = Vector2()

func get_input(delta):

	velocity.x = 0

	if Input.is_action_pressed("left"):
		velocity.x -= speed
	if Input.is_action_pressed("right"):
		velocity.x += speed
	if Input.is_action_pressed("jump"):
		if (is_on_floor()):
			velocity.y -= jump_speed
			
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	pass
	
func _physics_process(delta):
	get_input(delta)
