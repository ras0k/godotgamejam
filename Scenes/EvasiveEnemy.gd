extends Entity

export var flee_range = 200
export var aggro_range = 260
export var minimum_attack_range = 16

var direction : Vector2
var prev_direction = Vector2(0, 0)
var collision_cooldown = 0
# attempts to prevent enemies from trying to walk thru obstacles
var rng = RandomNumberGenerator.new()
var player = null

func _ready():
	player = get_tree().root.get_node("Main/Player")
	rng.randomize()


func _on_Timer_timeout():
	if not is_instance_valid(player):
		return
	var player_pos = player.position - position
	# calculate position of player relative to enemey
	if player_pos.length() <= aggro_range and player_pos.length() >= flee_range:
		direction = Vector2.ZERO
		$AnimationPlayer.play("Attack")
	elif player_pos.length() <= flee_range:
		# If player is within range, move toward it
		direction = -player_pos.normalized()
		$AnimationPlayer.play("Chase")
	elif collision_cooldown == 0:
		$AnimationPlayer.play("Idle")
		# psuedorandomly choose movement direction when not engaged with player
		var random_number = rng.randf()
		if random_number < 0.05:
			direction = Vector2.ZERO
		elif random_number < 0.1:
			direction = Vector2.DOWN.rotated(rng.randf() * 2 * PI)

	# Update collision cooldown
	if collision_cooldown > 0:
		collision_cooldown = collision_cooldown - 1

func _physics_process(delta):
	var movement = direction * speed * delta
	var collision = move_and_collide(movement)

	if collision != null and collision.collider.name != "Player":
		direction = direction.rotated(rng.randf_range(PI/4, PI/2))
		collision_cooldown = rng.randi_range(2, 5)


func _on_HurtArea_hurt(damage: int) -> void:
	health -= damage
	if health <= 0:
		queue_free()
