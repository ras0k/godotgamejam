extends RigidBody2D
onready var player = get_node("/root/Main/Spaceship")
onready var main = get_parent().get_parent().get_parent()

signal turned(degrees)

var frame := 0 
onready var flame1 = $Flame1
onready var flame2 = $Flame2
onready var flame3 = $Flame3
onready var flame4 = $Flame4
onready var flame5 = $Flame5
onready var flame6 = $Flame6
onready var flame7 = $Flame7
onready var flame8 = $Flame8


var flames_on := false
#var speed = player.speed
var speed = 8
var space_speed = speed
var planet_speed = speed / 8
export var kill_force : float = 42.0
var max_fuel := 2000.0
var fuel := 1600.0
var velocity = Vector2()
var ship_angle := 0
var rotation_dir := 0
var crash_counter := 0
var boost := 1.0
var max_boost := 2.4
var interstellar_fuel := 0.0
var current_planet
var on_planet := false

var collision_force : Vector2 = Vector2.ZERO
var previous_linear_velocity : Vector2 = Vector2.ZERO

func _integrate_forces(state : Physics2DDirectBodyState)->void:
	collision_force = Vector2.ZERO

	if state.get_contact_count() > 0:
		var dv : Vector2 = state.linear_velocity - previous_linear_velocity
		collision_force = dv / (state.inverse_mass * state.step) - state.total_gravity

	previous_linear_velocity = state.linear_velocity

func _ready() -> void:
	flame1.playing = true
	flame2.playing = true
	flame3.playing = true
	flame4.playing = true
	flame5.playing = true
	flame6.playing = true
	flame7.playing = true
	flame8.playing = true
	
	#$ExplosionSprite.playing = false


func flames_off() -> void:
	flame1.visible = false
	flame2.visible = false
	flame3.visible = false
	flame4.visible = false
	flame5.visible = false
	flame6.visible = false
	flame7.visible = false
	flame8.visible = false


func flames_on() -> void:
	flames_off()
	match frame:
		0, 1, 15:
			flame1.visible = true
			flame2.visible = true
		2:
			flame1.visible = true
			flame3.visible = true
		3, 4, 5:
			flame3.visible = true
			flame4.visible = true
		6:
			flame4.visible = true
			flame5.visible = true
		7, 8, 9:
			flame5.visible = true
			flame6.visible = true
		10:
			flame6.visible = true
			flame7.visible = true
		11, 12, 13:
			flame7.visible = true
			flame8.visible = true
		14:
			flame2.visible = true
			flame8.visible = true

func _physics_process(_delta):
#	trade()
#	launch()

	
	
	if Input.is_action_pressed("forward") and player.fuel > 0.0:
		$CPUParticles2D.emitting = true
	else: $CPUParticles2D.emitting = false

	if main.touching_ground:
		$Ship.frame = 0
		$CPUParticles2D.emitting = false
		
		if collision_force.y < -kill_force :
		#if true :
			$Ship.visible = false
			$ExplosionSprite.visible = true
			$ExplosionSprite.play("Explode")
			
			print(collision_force.y)
			
			
	else: 
		$Ship.frame = int(((ship_angle % 360) + 8) / (360.0/16.0)) % 16
	
	if Input.is_action_pressed("forward") and fuel > 0.0:
		velocity = planet_speed * Vector2(-cos(deg2rad(ship_angle + 90)), -sin(deg2rad(ship_angle + 90)))
#		fuel -= 0.8
		flames_on = true
		boost = 1.0
		if Input.is_action_pressed("boost") and fuel > 0.0:
			boost = max_boost
#			fuel -= max_boost * 0.8
	else:
		velocity = Vector2()
		flames_on = false

	if fuel > max_fuel:
		fuel = max_fuel

	if Input.is_action_pressed("left") and fuel > 0.0:
		turn_ship(-2)
#		fuel -= 0.25
	if Input.is_action_pressed("right") and fuel > 0.0:
		turn_ship(2)
#		fuel -= 0.25

	applied_force = velocity * boost
	rotation = 0


func turn_ship(angle: int):
	ship_angle += angle
	if ship_angle < 0:
		ship_angle += 360
	

func _on_ExplosionSprite_animation_finished():
	get_tree().reload_current_scene()
	pass # Replace with function body.
