extends KinematicBody2D

const speed = 30
const gravity = 5
const FLOOR = Vector2(0, -1)
var velocity = Vector2()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var direction = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _physics_process(delta):
	velocity.x = speed * direction
	if direction == 1:
		$CollisionShape2D/AnimatedSprite.flip_h = false
	else:
		$CollisionShape2D/AnimatedSprite.flip_h = true
	$CollisionShape2D/AnimatedSprite.play("walk")
	velocity.y += gravity
	velocity = move_and_slide(velocity, FLOOR)
	
	if is_on_wall():
		direction = direction * -1
		$RayCast2D.position.x *= -1
		
	if $RayCast2D.is_colliding() == false:
		direction = direction * -1
		$RayCast2D.position.x *= -1
		
#end
