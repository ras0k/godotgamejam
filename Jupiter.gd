extends Area2D

onready var player = get_node("/root/Main/Spaceship")
var shipSpeed: Vector2
var planetSpeed: Vector2
var relativeSpeed: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_Jupiter_body_entered(body):
	if body == player:
		player.fuel += 800
		if player.fuel > player.maxFuel:
			player.fuel = player.maxFuel
		print(shipSpeed)
		print(planetSpeed)
		print(relativeSpeed)
		print(relativeSpeed.length())
#		if relativeSpeed.length() > 3.0:
#			get_tree().reload_current_scene()
		
		

func _process(_delta):
		shipSpeed = player.linear_velocity
		planetSpeed = get_node("/root/Main/JupiterBody").linear_velocity
		relativeSpeed = planetSpeed - shipSpeed
