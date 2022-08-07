extends Control


onready var background: ProgressBar = $Background
onready var resource_bar: HBoxContainer = $ResourceBar

var inventory_capacity := 0


func _ready() -> void:
	pass


func update_inventory_ui(inventory: Array) -> void:
	if inventory.size() > inventory_capacity:
		background.value = 1 + inventory.size() * 2
	clear()
	for resource_type in inventory:
		add_resource(resource_type)


func clear() -> void:
	for resource in resource_bar.get_children():
		resource.queue_free()


func add_resource(type: int) -> void:
	var resource = create_resource_pip(Global.resource_colors[type])
	resource.name = Global.resource_types.keys()[type]
	$ResourceBar.add_child(resource)


func create_resource_pip(color: Color) -> ColorRect:
	var resource := ColorRect.new()
	resource.rect_min_size = Vector2.ONE
	resource.color = color
	return resource


