extends Entity

class_name Player


func _ready() -> void:
	$HitArea.enabled = false
	if is_instance_valid(Global.player):
		$HealthBar.value = Global.player.health
	else:
		spawn(max_health)


func _physics_process(_delta: float) -> void:
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
		
	if Input.is_action_pressed('dash'):
		if move_direction.length() > 0.1:
			dash()
	
	if $DashDuration.time_left == 0:
		debug_info.log_text('Dashing', 'false')
		$Sprite.self_modulate = Color(1,1,1,1)
		speed = 100
		
	if speed > 200:
		$Sprite.self_modulate = Color(2.85,1.99,2.42,0.47)		

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

	yield(get_tree().create_timer(.1), 'timeout')
	$HitArea.enabled = false
	debug_info.log_text('Attacking', 'false')


func _on_HurtArea_hurt(damage: int) -> void:
	health -= damage
	$HealthBar.value = health
	if health <= 0:
		queue_free()

func dash() -> void:
	if $DashCooldown.time_left > 0:
		return
	
	else:
		$DashDuration.start()
		$DashCooldown.start()
		speed = 250
		debug_info.log_text('Dashing', 'true') 
