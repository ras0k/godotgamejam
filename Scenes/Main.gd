extends Node2D

var room_number = 1
var current_room: DungeonRoom
var next_room: DungeonRoom

onready var transition_player: AnimationPlayer = $CanvasLayer/RoomTransition/AnimationPlayer


func _ready() -> void:
	Global.player = find_node('Player')
	# enter the first room fron the south
	change_room(DungeonRoom.directions.NORTH)


func change_room(exit_direction: int) -> void:
	next_room = load_room(room_number)
	room_number += 1

	transition_player.play('FadeIn')
	call_deferred('add_child_below_node', $CanvasLayer, next_room)
	next_room.visible = true
	yield(get_tree(), 'idle_frame')
	var direction := DungeonRoom.get_opposite_direction(exit_direction)
	var enter_position = next_room.get_room_enter_position(direction)

	yield(transition_player, 'animation_finished')
	if current_room:
		current_room.visible = false
		current_room.queue_free()

	Global.player.global_position = enter_position
	current_room = next_room
	transition_player.play_backwards('FadeIn')


func load_room(room_number: int) -> DungeonRoom:
	var room_path = 'res://Rooms/DungeonRoom_%s.tscn' % room_number
	var room_scene: PackedScene
	if ResourceLoader.exists(room_path):
		room_scene = ResourceLoader.load(room_path)
	else:
		room_scene = ResourceLoader.load('res://Rooms/DungeonRoom_1.tscn') # fallback to room 1

	var room: DungeonRoom = room_scene.instance()
	room.connect('exit_room', self, 'change_room')
	room.visible = false

	return room



