extends Entity


func _set_spawn():
	health = Global.global_player_health
	var spawn_point = Global.player_spawn_point
	self.global_position = spawn_point

func _ready() -> void:
	_set_spawn()
	$HitArea.enabled = false

func _physics_process(_delta: float) -> void:
	$ProgressBar.value = Global.global_player_health
	# Input.get_action_strength() to support analog movement.
	move_direction = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	if move_direction.length() > 1.0:
		move_direction = move_direction.normalized()
	move_and_slide(speed * move_direction)
	$HitArea.look_at(self.get_global_mouse_position())

	if Input.is_action_pressed('attack'):
		attack_melee()


func _process(delta: float) -> void:
	$Dust.emitting = move_direction.length() > .1


func _input(event: InputEvent) -> void:
	if event.is_action_pressed('attack'):
		attack_melee()


func attack_melee() -> void:
	if $AttackCooldownMelee.time_left > 0:
		return

	$AttackCooldownMelee.start()
	$HitArea.enabled = true
	debug_info.log_text('Attacking', 'true')

	yield(get_tree().create_timer(.3), 'timeout')
	$HitArea.enabled = false
	debug_info.log_text('Attacking', 'false')


func _on_HurtArea_hurt(damage: int) -> void:
	Global._update_player_health(damage)#see Global.gd
	health -= damage
	if health <= 0:
		queue_free()
