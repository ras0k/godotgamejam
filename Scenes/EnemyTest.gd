extends Entity

onready var ability_timer = $AbilityTimer
onready var default_speed = speed
onready var default_damage = $HitArea.damage
onready var start_position = global_position
# maximum range enemy will chase player from
export var aggro_range = 200
export var default_aggro_range = 200
export var minimum_attack_range = 30
export var wander_range = 180
export var ability_cooldown = 12.0
export var ability_range = 201
export var ability_duration = 1.0
var direction : Vector2
var prev_direction := Vector2(0, 0)
# attempts to prevent enemies from trying to walk thru obstacles
var collision_cooldown := 0
var rng := RandomNumberGenerator.new()
var player_pos

signal enemy_dead


func _ready():
#	debug_info.log_radius('aggro_range', aggro_range)
#	debug_info.log_radius('attack_range', minimum_attack_range)
	rng.randomize()
	spawn(max_health)



func _physics_process(delta):
	player_pos = Global.player.position - position
	$HealthBar.value = health
	move_direction = direction * speed * delta
	var collision = move_and_collide(move_direction)
	if collision != null and collision.collider.name != "Player":
		direction = direction.rotated(rng.randf_range(PI/4, PI/2))
		#changes direction by angle between 45 and 90 degrees if colliding with non player body


func _on_Timer_timeout():
	if not is_instance_valid(Global.player):
		return
	check_player_position()
	# Update collision timer
	if collision_cooldown > 0:
		collision_cooldown = collision_cooldown - 1



func _on_HurtArea_hurt(damage: int) -> void:
	health -= damage
	if health <= 0:
		queue_free()
		emit_signal('enemy_dead')

func wander():
	speed = default_speed
	$HitArea.damage = default_damage
		# pseudorandomly choose movement direction when not engaged with player
	var wander_pos = start_position - position
	var direction_chooser = rng.randi_range(0, 1)
	if wander_pos.length() >= wander_range:
		direction = wander_pos.normalized()
		debug_info.log_text('State', 'Returning')
	elif direction_chooser == 0:
		direction = Vector2.ZERO
		debug_info.log_text('State', 'Idle')
	elif direction_chooser == 1:
		direction = Vector2.DOWN.rotated(rng.randf() * 2 * PI)
		# awkward "random" direction chooser.
		debug_info.log_text('State', 'wander')

func attack():
	direction = Vector2.ZERO
	prev_direction = player_pos.normalized()
		# should help face sprite towards player when attacking after chasing
	debug_info.log_text('State', 'attack')

func chase():
	if ability_timer.time_left <= 0:
		charge()
	else:
		direction = player_pos.normalized()
		debug_info.log_text('State', 'Chase')

func check_player_position():
	if player_pos.length() <= minimum_attack_range and collision_cooldown <= 0:
		attack()

	elif player_pos.length() <= aggro_range:
		chase()

	elif collision_cooldown != 0:
		wander()

func charge():
	aggro_range = default_aggro_range * 2
	speed = speed * 2.5
	$HitArea.damage = $HitArea.damage * 1.5
	direction = player_pos.normalized()
	debug_info.log_text('State', 'Charge')
	$AbilityDuration.start(ability_duration)
	#check_player_position()

func _on_AbilityDuration_timeout():
	ability_timer.start(ability_cooldown)
	aggro_range = default_aggro_range
	speed = default_speed
	$HitArea.damage = default_damage
	check_player_position()
