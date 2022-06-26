extends KinematicBody2D

#consts
const speed = 60
const jump_power = -115
const gravity = 5
const FLOOR = Vector2(0, -1)
#vars
var velocity = Vector2()
var health = 100.0
var colliding_with_enemy = false
var enemy_health
var on_ground = false
var attacking = false
var in_dark = true
var is_dead = false
var party_hard = false

#signals
signal damage(value)

var status = {
	"colliding_with_enemy": false,
	"on_ground": false,
	"attacking": false,
	"in_dark": true
}

func get_flip(pressed):
	# This formula basically assures that if both right and left are pressed at the same time
	# the sprite direction will remain the same as it was before the press
	if party_hard:
		return !(pressed["right"] &&
				($AnimatedSprite.flip_h || !pressed["left"] && !$AnimatedSprite.flip_h))
	else:
		return pressed["left"] && (!pressed["right"] || pressed["right"] && $AnimatedSprite.flip_h)

func _ready():
	$AnimatedSprite.connect("animation_finished", self, "_on_AnimatedSprite_animation_finished",
							[$AnimatedSprite.animation])
	InputMap.add_action("party")
	var ev = InputEventKey.new()
	ev.scancode = KEY_P
	InputMap.action_add_event("party", ev)

func _physics_process(delta):
	if !is_dead:
		healthChecker()
		if Input.is_action_pressed("reset"):
			get_tree().reload_current_scene()

		if Input.is_action_just_pressed("party"):
			party_hard = !party_hard

		var pressed = {
			"up": Input.is_action_pressed("up"),
			"right": Input.is_action_pressed("right"),
			"left": Input.is_action_pressed("left"),
			"attack": Input.is_action_just_pressed("attack")
		}

		if pressed["attack"] && status["on_ground"]:
			status["attacking"] = true;
			velocity.x = 0
			$AnimatedSprite.play("attack")
		if !status["attacking"]:
			if status["on_ground"] && pressed["up"]:
				status["on_ground"] = false
				velocity.y = jump_power
			if pressed["right"] || pressed["left"]:
				$AnimatedSprite.flip_h = get_flip(pressed)
				velocity.x = speed * int(pressed["right"]) - speed * int(pressed["left"])
				$AnimatedSprite.play("idle" if pressed["right"] && pressed["left"] else "run")
			else:
				velocity.x = 0
				if status["on_ground"]:
					$AnimatedSprite.play("idle")

		velocity.y += gravity
		if !status["on_ground"]:
			if velocity.y < 0:
				$AnimatedSprite.play("jump")
			else:
				$AnimatedSprite.play("land")

		velocity = move_and_slide(velocity, FLOOR)

		status["on_ground"] = is_on_floor();

		for index in get_slide_count():
			var collision = get_slide_collision(index)
			if collision.collider.name.begins_with("Enemy"):
				status["colliding_with_enemy"] = true
			elif collision.collider.name.begins_with("Torch"):
				status["in_dark"] = false
			else:
				pass

		if status["colliding_with_enemy"] && status["attacking"]:
			damage()
			
		if status["in_dark"]:
			decrease_health()
			$HealthBar.value = health
		else:
			heal()
			$HealthBar.value = health

func healthChecker():
	if health <= 0:
		death()
		
func death():
	is_dead = true
	velocity = Vector2(0, 0)
	$AnimatedSprite.play("dead")
	$CollisionShape2D.disabled = true
	$Timer.start()

func damage():
	print(enemy_health)
	emit_signal("damage",1)

func decrease_health():
	if health > 0:
		health = health - 0.05

func _on_AnimatedSprite_animation_finished(name):
	status["attacking"] = false

func heal():
	if health < 100:
		health = health + 0.02

func _on_Torch_area_entered(area):
	status["in_dark"] = false

func _on_Torch_area_exited(area):
	status["in_dark"] = true

func _on_Timer_timeout():
	get_tree().change_scene("res://Scenes/TitleScreen.tscn")
