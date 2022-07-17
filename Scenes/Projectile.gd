extends Area2D


export var speed = 300
export var damage = 1
export(Vector2) var target
var direction
var move_direction

func _physics_process(delta):
	direction = target.normalized()
	move_direction = direction * speed
	global_position += move_direction * delta

func get_target():
	target = Global.player.global_position - global_position

func _on_Projectile_area_entered(area: Area2D):
	if area.has_method("hurt"):
		area.hurt(damage)
		queue_free()
	else:
		queue_free()
	
func _on_Timer_timeout():
	queue_free()
