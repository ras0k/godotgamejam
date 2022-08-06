extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var remaining_ore = 0 # temporary(?) solution to error when landed on this body and an asteroid is within player's
# mining range.

# Called when the node enters the scene tree for the first time.
func _ready():
	set_axis_velocity(Vector2(0,7) * 0.5)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	rotation = 0
#	pass
