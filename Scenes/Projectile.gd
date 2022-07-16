extends Area2D


export var speed = 400
export var damage = 1


func _physics_process(delta):
	position += transform.x * speed * delta


func _on_Projectile_area_entered(area: Area2D):
	if area.has_method("hurt"):
		area.hurt(damage)
		queue_free()
	else:
		queue_free()
	
func _on_Timer_timeout():
	queue_free()
