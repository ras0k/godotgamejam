extends Area2D

onready var ship = get_parent().get_node("Ship")

export var attraction_force = 1
export(float) var debug_scale

var affected_bodies = []

func _on_GravityWell_body_entered(body):
	if body == ship:
		affected_bodies.append(body)

func _on_GravityWell_body_exited(body):
	if body == ship:
		affected_bodies.remove(affected_bodies.find(body))

func _physics_process(_delta):
#	debug_info()
	$CollisionShape2D.scale = Vector2(debug_scale, debug_scale)
	
	for i in affected_bodies:
		if i.has_method("attract_to"):
			i.attract_to(global_position, attraction_force)

func debug_info():
	if Input.is_action_just_pressed("ui_focus_next"):
		print("***GRAVITY WELL START DEBUG INFO***")
		print("Ship node: " + str(ship))
		print("***GRAVITY WELL END DEBUG INFO***")
		print("")
