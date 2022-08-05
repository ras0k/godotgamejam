extends Node2D

onready var player = get_node("/root/Main/Spaceship")
onready var c = $CanvasLayer/CompassSprite


func _ready():
	$CanvasLayer/FlameSprite.playing = true
	$CanvasLayer/FlameSprite2.playing = true
	$CanvasLayer/FlameSprite3.playing = true
	$CanvasLayer/FlameSprite4.playing = true
	$CanvasLayer/FlameSprite5.playing = true
	$CanvasLayer/FlameSprite6.playing = true
	$CanvasLayer/FlameSprite7.playing = true
	$CanvasLayer/FlameSprite8.playing = true


func _process(_delta):
	flames_render()
	speed_meter()


func rotate_compass(frame: int) -> void:
	c.frame = frame


func flames_render():
	if player.flames_on == false:
		$CanvasLayer/FlameSprite.visible = false
		$CanvasLayer/FlameSprite2.visible = false
		$CanvasLayer/FlameSprite3.visible = false
		$CanvasLayer/FlameSprite4.visible = false
		$CanvasLayer/FlameSprite5.visible = false
		$CanvasLayer/FlameSprite6.visible = false
		$CanvasLayer/FlameSprite7.visible = false
		$CanvasLayer/FlameSprite8.visible = false
		return
	if c.frame == 1 or c.frame == 0 or c.frame == 15:
		$CanvasLayer/FlameSprite.visible = true
		$CanvasLayer/FlameSprite2.visible = true
		$CanvasLayer/FlameSprite3.visible = false
		$CanvasLayer/FlameSprite4.visible = false
		$CanvasLayer/FlameSprite5.visible = false
		$CanvasLayer/FlameSprite6.visible = false
		$CanvasLayer/FlameSprite7.visible = false
		$CanvasLayer/FlameSprite8.visible = false
	if c.frame == 2:
		$CanvasLayer/FlameSprite.visible = true
		$CanvasLayer/FlameSprite2.visible = false
		$CanvasLayer/FlameSprite3.visible = true
		$CanvasLayer/FlameSprite4.visible = false
		$CanvasLayer/FlameSprite5.visible = false
		$CanvasLayer/FlameSprite6.visible = false
		$CanvasLayer/FlameSprite7.visible = false
		$CanvasLayer/FlameSprite8.visible = false
	if c.frame == 3 or c.frame == 4 or c.frame == 5:
		$CanvasLayer/FlameSprite.visible = false
		$CanvasLayer/FlameSprite2.visible = false
		$CanvasLayer/FlameSprite3.visible = true
		$CanvasLayer/FlameSprite4.visible = true
		$CanvasLayer/FlameSprite5.visible = false
		$CanvasLayer/FlameSprite6.visible = false
		$CanvasLayer/FlameSprite7.visible = false
		$CanvasLayer/FlameSprite8.visible = false
	if c.frame == 6:
		$CanvasLayer/FlameSprite.visible = false
		$CanvasLayer/FlameSprite2.visible = false
		$CanvasLayer/FlameSprite3.visible = false
		$CanvasLayer/FlameSprite4.visible = true
		$CanvasLayer/FlameSprite5.visible = true
		$CanvasLayer/FlameSprite6.visible = false
		$CanvasLayer/FlameSprite7.visible = false
		$CanvasLayer/FlameSprite8.visible = false
	if c.frame == 7 or c.frame == 8 or c.frame == 9:
		$CanvasLayer/FlameSprite.visible = false
		$CanvasLayer/FlameSprite2.visible = false
		$CanvasLayer/FlameSprite3.visible = false
		$CanvasLayer/FlameSprite4.visible = false
		$CanvasLayer/FlameSprite5.visible = true
		$CanvasLayer/FlameSprite6.visible = true
		$CanvasLayer/FlameSprite7.visible = false
		$CanvasLayer/FlameSprite8.visible = false
	if c.frame == 10:
		$CanvasLayer/FlameSprite.visible = false
		$CanvasLayer/FlameSprite2.visible = false
		$CanvasLayer/FlameSprite3.visible = false
		$CanvasLayer/FlameSprite4.visible = false
		$CanvasLayer/FlameSprite5.visible = false
		$CanvasLayer/FlameSprite6.visible = true
		$CanvasLayer/FlameSprite7.visible = true
		$CanvasLayer/FlameSprite8.visible = false
	if c.frame == 11 or c.frame == 12 or c.frame == 13:
		$CanvasLayer/FlameSprite.visible = false
		$CanvasLayer/FlameSprite2.visible = false
		$CanvasLayer/FlameSprite3.visible = false
		$CanvasLayer/FlameSprite4.visible = false
		$CanvasLayer/FlameSprite5.visible = false
		$CanvasLayer/FlameSprite6.visible = false
		$CanvasLayer/FlameSprite7.visible = true
		$CanvasLayer/FlameSprite8.visible = true
	if c.frame == 14:
		$CanvasLayer/FlameSprite.visible = false
		$CanvasLayer/FlameSprite2.visible = true
		$CanvasLayer/FlameSprite3.visible = false
		$CanvasLayer/FlameSprite4.visible = false
		$CanvasLayer/FlameSprite5.visible = false
		$CanvasLayer/FlameSprite6.visible = false
		$CanvasLayer/FlameSprite7.visible = false
		$CanvasLayer/FlameSprite8.visible = true

func speed_meter():
	$CanvasLayer/SpeedMeter.value = 25 * clamp(get_node("/root/Main/SolarSystem/JupiterBody/Jupiter").relativeSpeed.length(), 0.5, 5.5)
