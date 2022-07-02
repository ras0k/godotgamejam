extends KinematicBody2D

# Movement speed in pixels per second.
export var speed := 250

onready var animation_tree := $AnimationTree


func _physics_process(_delta: float) -> void:
	# Input.get_action_strength() to support analog movement.
	var direction := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	# When aiming the joystick diagonally, the direction vector can have a length
	# greater than 1.0, making the character move faster than our maximum expected
	# speed. When that happens, we limit the vector's length to ensure the player
	# can't go beyond the maximum speed.
	if direction.length() > 1.0:
		direction = direction.normalized()
	move_and_slide(speed * direction)

	_animate_player()


func _animate_player():
	if Input.is_action_pressed("move_left"):
		$Sprite.flip_h = true;
		animation_tree.animate_movement(animation_tree.movement_states.SIDE)

	elif Input.is_action_pressed("move_right"):
		$Sprite.flip_h = false
		animation_tree.animate_movement(animation_tree.movement_states.SIDE)

	elif Input.is_action_pressed("move_down"):
		animation_tree.animate_movement(animation_tree.movement_states.DOWN)

	elif Input.is_action_pressed("move_up"):
		animation_tree.animate_movement(animation_tree.movement_states.UP)

	else:
		$Sprite.flip_h = false
		animation_tree.animate_movement(animation_tree.movement_states.IDLE)



