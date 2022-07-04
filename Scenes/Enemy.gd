extends Entity

# maximum range enemy will chase player from
export var aggro_range = 200
export var minimum_attack_range = 30
var direction : Vector2
var prev_direction := Vector2(0, 0)
# attempts to prevent enemies from trying to walk thru obstacles
var collision_cooldown := 0
var rng := RandomNumberGenerator.new()
var player = null


func _ready():
#	debug_info.log_radius('aggro_range', aggro_range)
#	debug_info.log_radius('attack_range', minimum_attack_range)
	_find_player_node()
	rng.randomize()
	spawn(max_health)


func _physics_process(delta):
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
		debug_info.log_text('State', 'attack')
	elif player_pos.length() <= aggro_range and collision_cooldown == 0:
		# If player is within range, move toward it
		direction = player_pos.normalized()
		debug_info.log_text('State', 'chase')
	elif collision_cooldown == 0:
		debug_info.log_text('State', 'wander')
		# pseudorandomly choose movement direction when not engaged with player
		var random_number = rng.randf()
		if random_number < 0.05:
			direction = Vector2.ZERO
		elif random_number < 0.1:
			direction = Vector2.DOWN.rotated(rng.randf() * 2 * PI)

	# Update collision cooldown
	if collision_cooldown > 0:
		collision_cooldown = collision_cooldown - 1

func _find_player_node():
	player = get_parent().find_node("Player")


func _on_HurtArea_hurt(damage: int) -> void:
	health -= damage
	$HealthBar.value = health
	if health <= 0:
		queue_free()
