extends RigidBody2D

var rng = RandomNumberGenerator.new()
var remaining_ore: float = 10.0
var resource_type: int = Global.resource_types.CURRENCY


func _ready():
	rng.randomize()
	$Sprite.frame = rng.randi_range(0, 4)
	$Sprite.rotation_degrees = rng.randi_range(0, 3) * 90
	pick_resource_type()
	modulate = Global.resource_colors[resource_type]
	if resource_type == Global.resource_types.EMPTY:
		modulate = Color.gray
	elif resource_type == Global.resource_types.CURRENCY:
		remaining_ore = rng.randf_range(40,240)
	elif resource_type == Global.resource_types.UPGRADE_MATERIAL:
		remaining_ore = rng.randf_range(40,120)
		


func _process(delta):
#	remaining_ore -= 0.1
	if remaining_ore <= 0:
		$Explosion.show()
		$Explosion.playing = true


func pick_resource_type():
	rng.randomize()
	match rng.randi_range(1, 10):
		1:
			resource_type = Global.resource_types.UPGRADE_MATERIAL
		2, 3, 4:
			resource_type = Global.resource_types.CURRENCY
		_:
			resource_type = Global.resource_types.EMPTY


func _on_Explosion_animation_finished() -> void:
	get_parent().remove_child(self)
	queue_free()
