extends ProgressBar

onready var player = get_node("/root/Main/Spaceship")

func _ready():
	max_value = player.max_fuel

func _physics_process(delta):
	value = player.fuel
	debug_info()

func debug_info():
	if Input.is_action_just_pressed("ui_focus_next"):
		print("***FUELBAR START DEBUG INFO***")
		print(str(max_value))
		print(str(value))
		print("***FUELBAR END DEBUG INFO***")
		print("")