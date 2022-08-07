extends Area2D

var line = Line2D.new()
var asteroid_positions := []


func _process(delta):
	asteroid_positions = []
	if get_parent().is_mining:
		mining()
	update()

func mining():
	for body in get_overlapping_bodies():
		asteroid_positions.append(body.global_position)
	if get_overlapping_bodies().size() == 0:
		asteroid_positions = []
	
func _draw():
	if asteroid_positions.size() > 0 and not get_parent().laser_toggle:
		for i in asteroid_positions.size():
			draw_line(Vector2.ZERO, asteroid_positions[i] - global_position, Color(0.2, 1, 0.1, 0.25), 1)
