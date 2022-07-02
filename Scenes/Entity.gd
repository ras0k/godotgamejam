extends KinematicBody2D

class_name Entity

# Movement speed in pixels per second.
export var speed := 100
export var max_health := 10
var health := max_health

onready var hit_area = $HitArea
onready var hurt_area = $HurtArea
onready var sprite := $Sprite
onready var animation_tree := $AnimationTree
enum movement_states { IDLE, UP, DOWN, RIGHT, LEFT }


func _ready() -> void:
	assert(hit_area is Area2D, "A Child node of type and name 'HitArea' is required")
	assert(hurt_area is Area2D, "A Child node of type and name 'HurtArea' is required")
	assert(sprite is Sprite, "A Child node of type and name 'Sprite' is required")
	assert(animation_tree is AnimationTree, "A Child node of type and name 'AnimationTree' is required")

	animation_tree.active = true


func animate_entity_movement(state: int):
	match state:
		movement_states.LEFT: # moving left is just moving right, but flipped
			sprite.flip_h = true;
			state = movement_states.RIGHT
		_:
			sprite.flip_h = false

	animation_tree.set('parameters/movement/current', state)


