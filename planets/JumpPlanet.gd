extends Area2D

onready var player = get_node("/root/Main/Spaceship")
var shipSpeed: Vector2
var planetSpeed: Vector2
var relativeSpeed: Vector2
var rng = RandomNumberGenerator.new()
var export_good
var import_good
enum goods { WHITE, BLUE, GREEN, RED }

func _ready():
	# semi-randomly chooses export resource for planet - see line 53
	pick_export()
	# semi-randomly chooses import resource for the planet - see line 67
	pick_import()
	# check to make sure export resource and import resource are not the same
	if export_good == import_good:
		pick_export()

# a function to detect the relative speed of the player and planet, if the relative speed is less than
# a certain amount, the player is able to land on the planet. Otherwise they will crash and die.
func _on_Jupiter_body_entered(body):
	if body == player:
		player.landed = true
		player.current_planet = self
		print(shipSpeed)
		print(planetSpeed)
		print(relativeSpeed)
		print(relativeSpeed.length())
		if relativeSpeed.length() > 5.0:
			if player.crash_counter == 0:
				get_node("/root/Main/Spaceship/ExplosionSprite").frame = 0
				get_node("/root/Main/Spaceship/ExplosionSprite").visible = true
				get_node("/root/Main/CanvasLayer/UI/Compass/ExplosionSprite").frame = 0
				get_node("/root/Main/CanvasLayer/UI/Compass/ExplosionSprite").visible = true
				get_node("/root/Main/Spaceship/ShipSprite").visible = false
				get_node("/root/Main/CanvasLayer/UI/Compass/Ship").visible = false
				player.crash_counter += 1
				print("Crashed!")
		else:
			print("Landed!")

func _process(_delta):
		shipSpeed = player.linear_velocity
		planetSpeed = get_node("/root/Main/SolarSystem/JumpPlanet").linear_velocity
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
