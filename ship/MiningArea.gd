extends Area2D

var line = Line2D.new()
var asteroid_positions := []

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	asteroid_positions = []
	if get_parent().is_mining:
		mining()
	update()
#	pass

func mining():
	for body in get_overlapping_bodies():
		asteroid_positions.append(body.position)
	if get_overlapping_bodies().size() == 0:
		asteroid_positions = []
	
func _draw():
	if asteroid_positions.size() > 0:
		for i in asteroid_positions.size():
			draw_line(Vector2.ZERO, asteroid_positions[i] - global_position, Color(0.2, 1, 0.1, 0.25), 1)
