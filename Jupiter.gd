extends Area2D

onready var player = get_node("/root/Main/Spaceship")
var shipSpeed: Vector2
var planetSpeed: Vector2
var relativeSpeed: Vector2
var rng = RandomNumberGenerator.new()
var export_good
var import_good
enum goods { WHITE, BLUE, GREEN, RED }

# Called when the node enters the scene tree for the first time.
func _ready():
	pick_export()
	pick_import()
	if export_good == import_good:
		pick_export()
#	pass # Replace with function body.

func _on_Jupiter_body_entered(body):
	if body == player:
		player.landed = true
		player.current_planet = self
		print(shipSpeed)
		print(planetSpeed)
		print(relativeSpeed)
		print(relativeSpeed.length())
		if relativeSpeed.length() > 4.0:
			if player.crash_counter == 0:
				get_node("/root/Main/Spaceship/ExplosionSprite").frame = 0
				get_node("/root/Main/Spaceship/ShipSprite").visible = false
				player.crash_counter += 1
				print("Crashed!")
		else:
			print("Landed!")


func _process(_delta):
		shipSpeed = player.linear_velocity
		planetSpeed = get_node("/root/Main/SolarSystem/JupiterBody").linear_velocity
		relativeSpeed = planetSpeed - shipSpeed
		if player.crash_counter > 0 :
			player.crash_counter += 1
		if player.crash_counter > 200:
				get_tree().reload_current_scene()

func _on_Jupiter_body_exited(body):
	player.landed = false

func pick_export():
	rng.randomize()
	var resource_picker = rand_range(0.0, 2.5)
	if resource_picker < 0.8:
		export_good = "white"
	elif resource_picker < 1.3:
		export_good = "blue"
	elif resource_picker < 2.0 :
		export_good = "green"
	elif resource_picker < 2.5 :
		export_good = "red"
#	else:
#		export_good = "black"

func pick_import():
	rng.randomize()
	var resource_picker = rand_range(0.0, 2.5)
	if resource_picker < 0.8:
		import_good = "white"
	elif resource_picker < 1.3:
		import_good = "blue"
	elif resource_picker < 2.0 :
		import_good = "green"
	elif resource_picker < 2.5 :
		import_good = "red"
#	else:
#		import_good = "black"
