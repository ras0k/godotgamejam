extends Entity

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


func _animate_player() -> void:
	if Input.is_action_pressed("move_left"):
		animate_entity_movement(movement_states.LEFT)

	elif Input.is_action_pressed("move_right"):
		animate_entity_movement(movement_states.RIGHT)

	elif Input.is_action_pressed("move_down"):
		animate_entity_movement(movement_states.DOWN)

	elif Input.is_action_pressed("move_up"):
		animate_entity_movement(movement_states.UP)

	else:
		animate_entity_movement(movement_states.IDLE)


func _on_HurtArea_hurt(damage: int) -> void:
	health -= damage
	if health <= 0:
		queue_free()
