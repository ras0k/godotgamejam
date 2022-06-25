extends KinematicBody2D

#consts
const speed = 60
const jump_power = -115
const gravity = 5
const FLOOR = Vector2(0, -1)
#vars
var velocity = Vector2()
var health = 100
var colliding_with_enemy = false
var enemy_health
var on_ground = false
var attacking = false
var in_dark = true
#signals
signal damage(value)

func _physics_process(delta):

	var up_pressed = Input.is_action_pressed("up")
	var right_pressed = Input.is_action_pressed("right")
	var left_pressed = Input.is_action_pressed("left")
	if !attacking && (up_pressed || right_pressed || left_pressed):
		if right_pressed || left_pressed:
			# This formula basically assures that if both right and left are pressed
			# at the same time the sprite direction will remain the same as it was
			# before the press
			$AnimatedSprite.flip_h = \
				!left_pressed && (right_pressed || $AnimatedSprite.flip_h) || \
				left_pressed && right_pressed && $AnimatedSprite.flip_h
			velocity.x = speed * int(right_pressed) - speed * int(left_pressed)
			$AnimatedSprite.play("idle" if right_pressed && left_pressed else "run")
		if on_ground && up_pressed:
			velocity.y = jump_power
			on_ground = false
	elif Input.is_action_just_pressed("attack"):
		attacking = true;
	elif attacking == true:
		$AnimatedSprite.play("attack")
	else:
		velocity.x = 0
		if on_ground && !attacking:
			$AnimatedSprite.play("idle")

	if Input.is_action_pressed("reset"):
		get_tree().reload_current_scene()

	velocity.y += gravity
	if is_on_floor():
		on_ground = true
	else:
		on_ground = false
		if velocity.y < 0:
			$AnimatedSprite.play("jump")
		else:
			$AnimatedSprite.play("land")

	velocity = move_and_slide(velocity, FLOOR)
	
			
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.name.begins_with("Enemy"):
			colliding_with_enemy = true
		elif collision.collider.name.begins_with("Torch"):
			in_dark = false
		else:
			pass
			
	if colliding_with_enemy && attacking:
		damage()
		
	if in_dark:
		decrease_health()
	else:
		heal()
		


func damage():
	print(enemy_health)
	emit_signal("damage",1)
	
func decrease_health():
		if health > 0:
			health = health - 0.05
			print(health)
func _on_AnimatedSprite_animation_finished():
	attacking=false
func heal():
		if health < 100:
			health = health + 0.05
			print(health)
func _on_Torch_area_entered(area):
	in_dark=false
func _on_Torch_area_exited(area):
	in_dark = true
