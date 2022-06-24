extends KinematicBody2D

var speed : int = 320
var jump_speed : int = 100
var gravity : int = 150
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
	if Input.is_action_pressed("reset"):
		get_tree().reload_current_scene()
			
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	pass
	
func _physics_process(delta):
	get_input(delta)
