extends Control

var frame := 0 setget set_frame
onready var flame1 = $Flame1
onready var flame2 = $Flame2
onready var flame3 = $Flame3
onready var flame4 = $Flame4
onready var flame5 = $Flame5
onready var flame6 = $Flame6
onready var flame7 = $Flame7
onready var flame8 = $Flame8


func _ready() -> void:
	flame1.playing = true
	flame2.playing = true
	flame3.playing = true
	flame4.playing = true
	flame5.playing = true
	flame6.playing = true
	flame7.playing = true
	flame8.playing = true


func set_frame(_frame: int) -> void:
	frame = _frame
	$Ship.frame = _frame


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
