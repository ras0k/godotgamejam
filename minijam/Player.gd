extends KinematicBody2D

const speed = 60
const jump_power = -115
const gravity = 5
const FLOOR = Vector2(0, -1)
var velocity = Vector2()

var on_ground = false
var attacking = false


func _physics_process(delta):

	if Input.is_action_pressed("right") && !attacking:
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.play("run")
		velocity.x = speed
	elif Input.is_action_pressed("left") && !attacking:
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.play("run")
		velocity.x = -speed
	elif Input.is_action_just_pressed("attack"):
		attacking = true;
	elif attacking == true:
		$AnimatedSprite.play("attack")
	else:
		velocity.x = 0
		if on_ground == true:
			if attacking == false:
				$AnimatedSprite.play("idle")
		
	if Input.is_action_pressed("up"):
		if on_ground == true:
			velocity.y = jump_power
			on_ground = false
			

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
		if collision.collider.begins_with("Enemy"):
			print("collided with", collision.collider.name)
		pass
 
func _on_AnimatedSprite_animation_finished():
	attacking=false
