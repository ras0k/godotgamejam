extends Node


export(Array, Resource) var items_array: Array = []

onready var randomPicker = $RandomPicker

func _ready():
	randomize()

func _physics_process(delta):
	if Input.is_action_just_pressed("generate"):
		print(randomPicker.pick_random_item())
