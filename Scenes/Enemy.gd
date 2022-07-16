extends Entity

# Base Enemy:
# attack animation will enable and disable attack HitArea. NYI

onready var start_position = global_position
# maximum range enemy will chase player from
export var aggro_range = 200
export var minimum_attack_range = 30
export var wander_range = 180
var direction : Vector2
var prev_direction := Vector2(0, 0)
# attempts to prevent enemies from trying to walk thru obstacles
var collision_cooldown := 0
var rng := RandomNumberGenerator.new()



signal enemy_dead


func _ready():
#	debug_info.log_radius('aggro_range', aggro_range)
#	debug_info.log_radius('attack_range', minimum_attack_range)
	rng.randomize()
	spawn(max_health)


func _physics_process(delta):
	$HealthBar.value = health
	move_direction = direction * speed * delta
	var collision = move_and_collide(move_direction)
	if collision != null and collision.collider.name != "Player":
		direction = direction.rotated(rng.randf_range(PI/4, PI/2))
		#changes direction by angle between 45 and 90 degrees if colliding with non player body


func _on_Timer_timeout():
	if not is_instance_valid(Global.player):
		return
	var player_pos = Global.player.global_position - global_position
	#calculate position of player relative to enemey
	if player_pos.length() <= minimum_attack_range:
		# enemy turn to face when close
		direction = Vector2.ZERO
		prev_direction = player_pos.normalized()
		# should help face sprite towards player when attacking after chasing
		debug_info.log_text('State', 'attack')
	elif player_pos.length() <= aggro_range and collision_cooldown == 0:
		# If player is within range, move toward it
		direction = player_pos.normalized()
		debug_info.log_text('State', 'chase')
	elif collision_cooldown == 0:
		debug_info.log_text('State', 'wander')
		# pseudorandomly choose movement direction when not engaged with player
		var wander_pos = start_position - global_position
		var direction_chooser = rng.randf()
		if wander_pos.length() >= wander_range:
			direction = wander_pos.normalized()
		elif direction_chooser < 0.05:
			direction = Vector2.ZERO
		elif direction_chooser < 0.1:
			direction = Vector2.DOWN.rotated(rng.randf() * 2 * PI)

	# Update collision cooldown
	if collision_cooldown > 0:
		collision_cooldown = collision_cooldown - 1


func _on_HurtArea_hurt(damage: int) -> void:
	health -= damage
	if health <= 0:
		queue_free()
		emit_signal('enemy_dead')


