extends Control

onready var player = get_node("/root/Main/Spaceship")
onready var main = get_node("/root/Main")
onready var compass = $Compass


func _ready():
	pass


func _process(_delta):
#	if player.trading:
#		$PauseMenu.visible = false
	if player.flames_on:
		compass.flames_on()
	else:
		compass.flames_off()

	pause()
	update_speed_meter()
	update_resource_meter()


func rotate_compass(frame: int) -> void:
	compass.frame = frame


func update_speed_meter():
	$SpeedMeter.value = 25 * clamp(get_node("/root/Main/SolarSystem/JumpPlanet/LandingArea").relativeSpeed.length(), 0.5, 5.5)


func update_resource_meter():
	pass
#	$White.value = Global.white_resource_amount
#	$Blue.value = Global.blue_resource_amount
#	$Green.value = Global.green_resource_amount
#	$Red.value = Global.red_resource_amount

func pause():
	if main.pause_state == "running":
		$PauseMenu.visible = false
	elif main.pause_state == "paused":
		$PauseMenu.visible = true
	elif main.pause_state == "on_planet":
		$PauseMenu.visible = false
