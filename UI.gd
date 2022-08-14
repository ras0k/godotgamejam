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

	handle_pause()
	update_speed_meter()


func rotate_compass(frame: int) -> void:
	compass.frame = frame


func update_speed_meter():
	$SpeedMeter.value = 25 * clamp(get_node("/root/Main/SolarSystem/JumpPlanet/LandingArea").relativeSpeed.length(), 0.5, 5.5)


func update_mining_progress(value: float, resource_type: int):
	if is_zero_approx($MiningProgress.value):
		$MiningProgress.visible = false
		$BlueMiningProgress.get_stylebox('bg').expand_margin_bottom = 1
	else:
		$MiningProgress.visible = true
		$BlueMiningProgress.get_stylebox('bg').expand_margin_bottom = 0
	if is_zero_approx($BlueMiningProgress.value):
		$BlueMiningProgress.visible = false
	else:
		$BlueMiningProgress.visible = true
	
	if resource_type == 1:
		$MiningProgress.value = value
		$MiningProgress.get_stylebox('fg').bg_color = Global.resource_colors[1]
	elif resource_type == 2:
		$BlueMiningProgress.value = value
		$BlueMiningProgress.get_stylebox('fg').bg_color = Global.resource_colors[2]
	



func update_inventory(inventory: Array):
	if inventory.size() > $Inventory.capacity:
		$Inventory.background.value = 1 + inventory.size() * 2
	$Inventory.clear()
	for resource_type in inventory:
		$Inventory.add_resource(resource_type)


func handle_pause():
	if main.pause_state == "running":
		$PauseMenu.visible = false
	elif main.pause_state == "paused":
		$PauseMenu.visible = true
	elif main.pause_state == "on_planet":
		$PauseMenu.visible = false



func _on_Restart_pressed():
	get_tree().change_scene("res://StartMenu.tscn")
	pass # Replace with function body.
