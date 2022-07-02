extends KinematicBody2D


export var aggro_range = 200
#maximum range enemy will chase player from
export var speed = 110
#speed
var direction : Vector2
#direction
var prev_direction = Vector2(0, 0)
#previous direction
var collisionCD = 0
#attempts to prevent enemies from trying to walk thru obstacles
var rng = RandomNumberGenerator.new()
var player = null

func _ready():
	player = get_tree().root.get_node("Main/Player")
	rng.randomize()
	

func _on_Timer_timeout():
	var player_pos = player.position - position
	#calculate position of player relative to enemey
	if player_pos.length() <= 16:
		#enemy turn to face when close
		direction = Vector2.ZERO
		prev_direction = player_pos.normalized()
		$AnimationPlayer.play("Chase")
	elif player_pos.length() <= aggro_range and collisionCD == 0:
		# If player is within range, move toward it
		direction = player_pos.normalized()
		$AnimationPlayer.play("Chase")
	elif collisionCD == 0:
		$AnimationPlayer.play("Idle")
		#psuedorandomly choose movement direction when not engaged with player
		var random_number = rng.randf()
		if random_number < 0.05:
			direction = Vector2.ZERO
		elif random_number < 0.1:
			direction = Vector2.DOWN.rotated(rng.randf() * 2 * PI)
	
	# Update collision cooldown
	if collisionCD > 0:
		collisionCD = collisionCD - 1

func _physics_process(delta):
	var movement = direction * speed * delta
	#movement
	
	var collision = move_and_collide(movement)
	#collision
	
	if collision != null and collision.collider.name != "Player":
		direction = direction.rotated(rng.randf_range(PI/4, PI/2))
		collisionCD = rng.randi_range(2, 5)
