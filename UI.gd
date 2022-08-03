extends CanvasLayer


onready var player = get_node("/root/Main/Spaceship")
onready var c = $compassSprite


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	flames_render()
	speed_meter()


func flames_render():
	if player.flames_on == false:
		$FlameSprite.visible = false
		$FlameSprite2.visible = false
		$FlameSprite3.visible = false
		$FlameSprite4.visible = false
		$FlameSprite5.visible = false
		$FlameSprite6.visible = false
		$FlameSprite7.visible = false
		$FlameSprite8.visible = false
		return
	if c.frame == 1 or c.frame == 0 or c.frame == 15:
		$FlameSprite.visible = true
		$FlameSprite2.visible = true
		$FlameSprite3.visible = false
		$FlameSprite4.visible = false
		$FlameSprite5.visible = false
		$FlameSprite6.visible = false
		$FlameSprite7.visible = false
		$FlameSprite8.visible = false
	if c.frame == 2:
		$FlameSprite.visible = true
		$FlameSprite2.visible = false
		$FlameSprite3.visible = true
		$FlameSprite4.visible = false
		$FlameSprite5.visible = false
		$FlameSprite6.visible = false
		$FlameSprite7.visible = false
		$FlameSprite8.visible = false
	if c.frame == 3 or c.frame == 4 or c.frame == 5:
		$FlameSprite.visible = false
		$FlameSprite2.visible = false
		$FlameSprite3.visible = true
		$FlameSprite4.visible = true
		$FlameSprite5.visible = false
		$FlameSprite6.visible = false
		$FlameSprite7.visible = false
		$FlameSprite8.visible = false
	if c.frame == 6:
		$FlameSprite.visible = false
		$FlameSprite2.visible = false
		$FlameSprite3.visible = false
		$FlameSprite4.visible = true
		$FlameSprite5.visible = true
		$FlameSprite6.visible = false
		$FlameSprite7.visible = false
		$FlameSprite8.visible = false
	if c.frame == 7 or c.frame == 8 or c.frame == 9:
		$FlameSprite.visible = false
		$FlameSprite2.visible = false
		$FlameSprite3.visible = false
		$FlameSprite4.visible = false
		$FlameSprite5.visible = true
		$FlameSprite6.visible = true
		$FlameSprite7.visible = false
		$FlameSprite8.visible = false
	if c.frame == 10:
		$FlameSprite.visible = false
		$FlameSprite2.visible = false
		$FlameSprite3.visible = false
		$FlameSprite4.visible = false
		$FlameSprite5.visible = false
		$FlameSprite6.visible = true
		$FlameSprite7.visible = true
		$FlameSprite8.visible = false
	if c.frame == 11 or c.frame == 12 or c.frame == 13:
		$FlameSprite.visible = false
		$FlameSprite2.visible = false
		$FlameSprite3.visible = false
		$FlameSprite4.visible = false
		$FlameSprite5.visible = false
		$FlameSprite6.visible = false
		$FlameSprite7.visible = true
		$FlameSprite8.visible = true
	if c.frame == 14:
		$FlameSprite.visible = false
		$FlameSprite2.visible = true
		$FlameSprite3.visible = false
		$FlameSprite4.visible = false
		$FlameSprite5.visible = false
		$FlameSprite6.visible = false
		$FlameSprite7.visible = false
		$FlameSprite8.visible = true

func speed_meter():
	$SpeedMeter.value = 25 * clamp(get_node("/root/Main/JupiterBody/Jupiter").relativeSpeed.length(), 0.0, 4.0)
