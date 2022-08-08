extends RigidBody2D

var rng = RandomNumberGenerator.new()
var remaining_ore: float = rng.randf_range(40.0, 240.0)
var resource_type: int = Global.resource_types.CURRENCY


func _ready():
	$Sprite.frame = int(rng.randi_range(0, 4))
	pick_resource_type()
	modulate = Global.resource_colors[resource_type]


func _process(delta):
	remaining_ore -= 0.1
	if remaining_ore <= 0:
		$Explosion.show()
		$Explosion.playing = true


func pick_resource_type():
	rng.randomize()
	if rng.randi_range(1, 5) == 1:
		resource_type = Global.resource_types.UPGRADE_MATERIAL


func _on_Explosion_animation_finished() -> void:
	get_parent().remove_child(self)
	queue_free()
