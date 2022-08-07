extends Control

onready var player = get_node("/root/Main/Spaceship")
onready var compass = $Compass

func _ready():
	$PauseMenu.visible = false


func _process(_delta):
	$PauseMenu.visible = get_tree().paused
	if player.trading:
		$PauseMenu.visible = false
	if player.flames_on:
		compass.flames_on()
	else:
		compass.flames_off()

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
