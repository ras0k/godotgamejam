extends Entity

onready var start_position = global_position

export var flee_range = 180
export var aggro_range = 300
export var minimum_attack_range = 250
export var wander_range = 180

var direction : Vector2
var prev_direction = Vector2(0, 0)
var collision_cooldown = 0
# attempts to prevent enemies from trying to walk thru obstacles
var rng = RandomNumberGenerator.new()

func _ready():
#	debug_info.log_radius('aggro_range', aggro_range)
#	debug_info.log_radius('flee_range', flee_range)
#	debug_info.log_radius('minimum_attack_range', minimum_attack_range)
	rng.randomize()
	spawn(max_health)


signal enemy_dead


func _physics_process(delta):
	move_direction = direction * speed * delta
	var collision = move_and_collide(move_direction)

	if collision != null and collision.collider.name != "Player":
		direction = direction.rotated(rng.randf_range(PI/4, PI/2))
		collision_cooldown = rng.randi_range(2, 5)


func _on_Timer_timeout():
	if not is_instance_valid(Global.player):
		return
	var player_pos = Global.player.position - position
	# calculate position of player relative to enemey
	if player_pos.length() <= minimum_attack_range and player_pos.length() >= flee_range:
		direction = Vector2.ZERO
		debug_info.log_text('State', 'attack')
	elif player_pos.length() <= flee_range:
		# If player is within range, move away
		direction = -player_pos.normalized()
		debug_info.log_text('State', 'flee')
	elif player_pos.length() <= aggro_range and collision_cooldown == 0:
		# If player is within range, chase after it
		direction = player_pos.normalized()
		debug_info.log_text('State', 'chase')
	elif collision_cooldown == 0:
		debug_info.log_text('State', 'idle')
		# psuedorandomly choose movement direction when not engaged with player
		var wander_pos = start_position - position
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
	$HealthBar.value = health
	if health <= 0:
		queue_free()
		emit_signal('enemy_dead')
