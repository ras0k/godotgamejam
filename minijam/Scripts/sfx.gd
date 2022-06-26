extends Node


#var walking = load("res://SFX/Footsteps.ogg")

func _ready():
	pass


func play_walking():
	if not $Walking.playing:
		$Walking.play()

func stop_walking():
	$Walking.stop()
	
func play_jumping():
	if not $Jumping.playing:
		$Jumping.play()

func stop_jumping():
	$Jumping.stop()

func play_hit():
	if not $Hit.playing:
		$Hit.play()

func stop_hit():
	$Hit.stop()

func play_dead():
	if not $Dead.playing:
		$Dead.play()

func stop_dead():
	$Dead.stop()
