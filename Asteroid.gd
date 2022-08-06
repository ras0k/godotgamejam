extends RigidBody2D

var remaining_ore := rand_range(40.0, 240.0)
var rng = RandomNumberGenerator.new()
var resource_type

func _ready():
	# semi-randomly generates the resource mineable from the body - see line 27
	pick_resource_type()
	$Sprite.frame = int(rand_range(0.0,8.0))
	angular_velocity = rand_range(-1.0,2.0)
	position += Vector2 (rand_range(-20.0,20.0),rand_range(-20.0,20.0))


func _process(delta):
	if remaining_ore <= 0:
		get_parent().remove_child(self)

func pick_resource_type():
	rng.randomize()
	var resource_picker = rand_range(0.0, 2.5)
	if resource_picker < 0.8:
		resource_type = "white"
	elif resource_picker < 1.3:
		resource_type = "blue"
	elif resource_picker < 2.0 :
		resource_type = "green"
	elif resource_picker < 2.5 :
		resource_type = "red"
	else:
		resource_type = "black"
