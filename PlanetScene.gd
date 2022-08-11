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
		
	pass # Replace with function body.


func _on_PlanetShip_body_exited(body):
	print("now departing from : " + str(body))
	
	if body is RigidBody2D:
		main.touching_ground = false

#basic menu toggle
func _on_alien_toggled(button_pressed):
	$planet_bg/Control/alien_panel.visible = button_pressed
	if button_pressed :
		$planet_bg/Control/hangar.pressed = false
		$planet_bg/Control/fuel.pressed = false

func _on_fuel_toggled(button_pressed):
	$planet_bg/Control/fuel_panel.visible = button_pressed
	if button_pressed :
		$planet_bg/Control/alien.pressed = false
		$planet_bg/Control/hangar.pressed = false

func _on_hangar_toggled(button_pressed):
	$planet_bg/Control/hangar_panel.visible = button_pressed
	if button_pressed :
		$planet_bg/Control/fuel.pressed = false
		$planet_bg/Control/alien.pressed = false
