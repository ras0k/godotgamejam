extends KinematicBody2D

const speed = 30
const gravity = 5
const FLOOR = Vector2(0, -1)
var velocity = Vector2()
var is_dead = false
var health = 3
var colliding_with_player = false

var direction = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func dead():
	print_debug("dead")
	is_dead = true
	velocity = Vector2(0, 0)
	$CollisionShape2D/AnimatedSprite.play("dead")
	$CollisionShape2D.disabled = true
	$Timer.start()
	
func _physics_process(delta):
	if is_dead == false:
		velocity.x = speed * direction
		if direction == 1:
			$CollisionShape2D/AnimatedSprite.flip_h = false
		else:
			$CollisionShape2D/AnimatedSprite.flip_h = true
		$CollisionShape2D/AnimatedSprite.play("walk")
		velocity.y += gravity
		velocity = move_and_slide(velocity, FLOOR)
		
		for index in get_slide_count():
			var collision = get_slide_collision(index)
			if collision.collider.name.begins_with("Player"):
				colliding_with_player = true
			else:
				pass
		
	if is_on_wall():
		direction = direction * -1
		$RayCast2D.position.x *= -1
		
	if $RayCast2D.is_colliding() == false:
		direction = direction * -1
		$RayCast2D.position.x *= -1
			

func _on_Player_damage(value):
	health -= health
	if health <= 0:
		dead()


func _on_Timer_timeout():
	queue_free()
