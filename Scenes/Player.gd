extends Entity


func _physics_process(_delta: float) -> void:
	# Input.get_action_strength() to support analog movement.
	move_direction = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	# When aiming the joystick diagonally, the direction vector can have a length
	# greater than 1.0, making the character move faster than our maximum expected
	# speed. When that happens, we limit the vector's length to ensure the player
	# can't go beyond the maximum speed.
	if move_direction.length() > 1.0:
		move_direction = move_direction.normalized()
	move_and_slide(speed * move_direction)

	$Dust.emitting = move_direction.length() > .1


func _on_HurtArea_hurt(damage: int) -> void:
	health -= damage
	if health <= 0:
		queue_free()
