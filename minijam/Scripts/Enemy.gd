extends KinematicBody2D

const speed = 30
const gravity = 5
const FLOOR = Vector2(0, -1)
var velocity = Vector2()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _physics_process(delta):
	velocity.x = speed
	$AnimatedSprite.play("walk")
	velocity.y += gravity
	velocity = move_and_slide(velocity, FLOOR)
#end
