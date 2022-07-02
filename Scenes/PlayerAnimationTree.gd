extends AnimationTree

enum movement_states { IDLE, SIDE, UP, DOWN }


func _ready() -> void:
	active = true


func animate_movement(state: int) -> void:
#	assert(state in movement_states)
	set('parameters/movement/current', state)




