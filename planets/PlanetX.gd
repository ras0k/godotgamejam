extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var remaining_ore = 0 # temporary(?) solution to error when landed on this body and an asteroid is within player's
# mining range.


# Called when the node enters the scene tree for the first time.
func _ready():
	set_axis_velocity(Vector2(-2 , 16) * 0.5)
	$Sprite.frame = int(rand_range(0.0, 11.99)) 


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
