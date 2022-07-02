extends KinematicBody2D


export var A = 200
#maximum range enemy will chase player from
export var S = 110
#speed
var D : Vector2
#direction
var prevD = Vector2(0, 0)
#previous direction
var collisionCD = 0
#attempts to prevent enemies from trying to walk thru obstacles
var rng = RandomNumberGenerator.new()
var player = null

func _ready():
	player = get_tree().root.get_node("Main/Player")
	rng.randomize()
	

func _on_Timer_timeout():
	var pPos = player.position - position
	#calculate position of player relative to enemey
	if pPos.length() <= 16:
		#enemy turn to face when close
		D = Vector2.ZERO
		prevD = pPos.normalized()
		$AnimationPlayer.play("Chase")
	elif pPos.length() <= A and collisionCD == 0:
		# If player is within range, move toward it
		D = pPos.normalized()
		$AnimationPlayer.play("Chase")
	elif collisionCD == 0:
		$AnimationPlayer.play("Idle")
		#psuedorandomly choose movement direction when not engaged with player
		var random_number = rng.randf()
		if random_number < 0.05:
			D = Vector2.ZERO
		elif random_number < 0.1:
			D = Vector2.DOWN.rotated(rng.randf() * 2 * PI)
	
	# Update collision cooldown
	if collisionCD > 0:
		collisionCD = collisionCD - 1

func _physics_process(delta):
	var M = D * S * delta
	#movement
	
	var C = move_and_collide(M)
	#collision
	
	if C != null and C.collider.name != "Player":
		D = D.rotated(rng.randf_range(PI/4, PI/2))
		collisionCD = rng.randi_range(2, 5)
