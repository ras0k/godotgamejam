extends Node2D

onready var player = get_node("../Spaceship")
onready var main = get_node("/root/Main")
onready var ui = get_node("/root/Main/CanvasLayer/UI")

var counter := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$planet_bg.position.y = 112


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	counter += 1
	if counter % 30 == 0 and counter < 280:
		$planet_bg.position.y -= 1
	
	if $PlanetShip.position.y > 24:
		$PlanetShip/CPUParticles2D.damping = 5 + ($PlanetShip.position.y - 24) * 2
	else: 
		$PlanetShip/CPUParticles2D.damping = 5


func _on_PlanetShip_body_entered(body):
	print("now touching with : " + str(body))
	if body is RigidBody2D:
		main.touching_ground = true
		ui.show_upgrades(true)
	pass # Replace with function body.


func _on_PlanetShip_body_exited(body):
	print("now departing from : " + str(body))
	
	if body is RigidBody2D:
		main.touching_ground = false
		ui.show_upgrades(false)
		
	pass # Replace with function body.
