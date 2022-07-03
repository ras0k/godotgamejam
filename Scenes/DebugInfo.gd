extends Node2D

class_name DebugInfo

var parent_node: Node setget attach
var _offset := Vector2()

func _ready() -> void:
	if OS.is_debug_build():
		if not ProjectSettings.get_setting("global/show_debug"):
			visible = false
			print('Info: Project setting "global/show_debug" is disabled.')


func attach(node: Node) -> DebugInfo:
	node.add_child(self)
	return self


func offset(value:Vector2) -> DebugInfo:
	_offset = value
	position += value
	return self


func log_text(name: String, text: String):
	var label: Label = $Panel/VBoxContainer.get_node_or_null(name)
	if not label:
		label = Label.new()
		label.name = name
		$Panel/VBoxContainer.add_child(label)
	label.text = name + ": " + text


# only works when debug collision shapes visible
func log_radius(name: String, radius):
	if not (typeof(radius) == TYPE_INT or typeof(radius) == TYPE_REAL):
		return
	var shape: CollisionShape2D = get_node_or_null(name)
	if not shape:
		shape = CollisionShape2D.new()
		shape.name = name
		add_child(shape)
		shape.shape = CircleShape2D.new()
	shape.shape.radius = radius
