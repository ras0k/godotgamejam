extends ProgressBar

onready var player = get_node("/root/Main/Spaceship")

func _ready():
	max_value = player.max_fuel

func _physics_process(delta):
	value = player.fuel
