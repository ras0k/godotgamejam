extends Node


var main_loop = load("res://Sound/cavemind_loop.ogg")

func _ready():
	pass

func play_music():
	$Music.stream = main_loop
	$Music.play()
