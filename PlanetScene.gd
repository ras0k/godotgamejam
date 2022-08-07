extends Node2D

onready var player = get_node("../Spaceship")
onready var main = get_node("/root/Main")

var counter := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$planet_bg.position.y = 112


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	counter += 1
	if counter % 30 == 0 and counter < 280:
		$planet_bg.position.y -= 1
