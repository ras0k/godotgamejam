extends RigidBody2D

export var initial_velocity := Vector2.ZERO

var remaining_ore = 0 # temporary(?) solution to error when landed on this body and an asteroid is within player's


func _ready():
	set_axis_velocity(initial_velocity)
	$Sprite.frame = int(rand_range(0.0 , 11.99))



