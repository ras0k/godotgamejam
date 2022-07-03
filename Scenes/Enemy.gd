extends Entity

export var aggro_range = 200
# maximum range enemy will chase player from
export var minimum_attack_range = 30

var direction : Vector2
var prev_direction := Vector2(0, 0)
var collision_cooldown := 0
# attempts to prevent enemies from trying to walk thru obstacles
var rng := RandomNumberGenerator.new()
var player = null


func _ready():
	$DebugInfo.log_radius('aggro_range', aggro_range)
	$DebugInfo.log_radius('attack_range', minimum_attack_range)
	player = get_tree().root.get_node("Main/Player")
	rng.randomize()


func _physics_process(delta):
	._physics_process(delta)
	move_direction = direction * speed * delta
	var collision = move_and_collide(move_direction)

	if collision != null and collision.collider.name != "Player":
		direction = direction.rotated(rng.randf_range(PI/4, PI/2))
		collision_cooldown = rng.randi_range(2, 5)


func _on_Timer_timeout():
	if not is_instance_valid(player):
		return
	var player_pos = player.position - position
	#calculate position of player relative to enemey
	if player_pos.length() <= minimum_attack_range:
		# enemy turn to face when close
		direction = Vector2.ZERO
		prev_direction = player_pos.normalized()
		$DebugInfo.log_text('State', 'attack')
	elif player_pos.length() <= aggro_range and collision_cooldown == 0:
		# If player is within range, move toward it
		direction = player_pos.normalized()
		$DebugInfo.log_text('State', 'chase')
	elif collision_cooldown == 0:
		$DebugInfo.log_text('State', 'wander')
		# pseudorandomly choose movement direction when not engaged with player
		var random_number = rng.randf()
		if random_number < 0.05:
			direction = Vector2.ZERO
		elif random_number < 0.1:
			direction = Vector2.DOWN.rotated(rng.randf() * 2 * PI)

	# Update collision cooldown
	if collision_cooldown > 0:
		collision_cooldown = collision_cooldown - 1


func _on_HurtArea_hurt(damage: int) -> void:
	health -= damage
	if health <= 0:
		queue_free()
