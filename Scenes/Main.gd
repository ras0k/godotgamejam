extends Node2D

var room_coordinate := Vector2.ZERO
var current_room: DungeonRoom
var next_room: DungeonRoom

onready var transition_player: AnimationPlayer = $CanvasLayer/RoomTransition/AnimationPlayer

var rooms := {}
# dictionary of room coordinates with their clear status
# (2, 0): true -> room at x2, y0 is cleared
# if a room is not in here, it does not exist as a neighbor to any other room
# a room layout could look something like this for example
# 0_0 is always the starting room
# |     |     | 0_2 | 1_2 |     |
# |     |     | 0_1 | 1_1 | 2_1 |
# |-2_0 |-1_0 | 0_0 |     | 2_0 |

func _ready() -> void:
	Global.player = find_node('Player')
	walk_rooms_directory()

	$MixingDeskMusic.init_song('MainTheme')
	$MixingDeskMusic.play('MainTheme')
	$MixingDeskMusic.mute('MainTheme', 'Layer3Synth')
	$MixingDeskMusic.mute('MainTheme', 'PercussionBass')
	$MixingDeskMusic.mute('MainTheme', 'PercussionMetals')
	$MixingDeskMusic.mute('MainTheme', 'PercussionSlap')

	# enter the first room fron the south
	enter_room(DungeonRoom.directions.SOUTH)


func change_room(exit_direction: int) -> void:
	match exit_direction:
		DungeonRoom.directions.NORTH:
			room_coordinate += Vector2(0, 1)
		DungeonRoom.directions.SOUTH:
			room_coordinate += Vector2(0, -1)
		DungeonRoom.directions.EAST:
			room_coordinate += Vector2(1, 0)
		DungeonRoom.directions.WEST:
			room_coordinate += Vector2(-1, 0)
	print('change room to %s' % room_coordinate)
	var direction := DungeonRoom.get_opposite_direction(exit_direction)
	enter_room(direction)


func enter_room(enter_direction: int) -> void:
	next_room = load_room(room_coordinate)
	transition_player.play('FadeIn')
	call_deferred('add_child_below_node', $CanvasLayer, next_room)
	yield(get_tree(), 'idle_frame')
	next_room = setup_room_portals(room_coordinate, next_room)
	next_room.visible = true
	var enter_position = next_room.get_room_enter_position(enter_direction)

	Global.player.get_parent().remove_child(Global.player)
	yield(transition_player, 'animation_finished')
	if current_room:
		current_room.visible = false
		current_room.queue_free()

	next_room.add_child(Global.player)
	Global.player.global_position = enter_position
#	current_room.is_cleared =
	current_room = next_room
	transition_player.play_backwards('FadeIn')
	if not current_room.is_cleared:
		start_battle_music()


func load_room(coordinate: Vector2) -> DungeonRoom:
	var room_path = 'res://Rooms/%s_%s.tscn' % [coordinate.x, coordinate.y]
	var room_scene: PackedScene
	if ResourceLoader.exists(room_path):
		room_scene = ResourceLoader.load(room_path)
	else:
		printerr('not a valid room coordinate: %s' % coordinate)
		room_coordinate = Vector2.ZERO
		room_scene = ResourceLoader.load('res://Rooms/0_0.tscn') # fallback to room 1

	var room: DungeonRoom = room_scene.instance()
	room.visible = false
	room.connect('exit_room', self, 'change_room')
	room.connect('room_cleared', self, 'mark_room_cleared')

	if rooms.has(coordinate) and rooms[coordinate] == true:
		room.is_cleared = true

	return room


func setup_room_portals(room_coordinate: Vector2, dungeon_room: DungeonRoom) -> DungeonRoom:
	dungeon_room.set_portal_directions(
		rooms.has(room_coordinate + Vector2(0, 1)),
		rooms.has(room_coordinate + Vector2(0, -1)),
		rooms.has(room_coordinate + Vector2(1, 0)),
		rooms.has(room_coordinate + Vector2(-1, 0))
	)
	next_room.is_open = rooms.has(room_coordinate) and rooms[room_coordinate] == true
	return dungeon_room


func mark_room_cleared() -> void:
	if rooms[room_coordinate] == true:
		return
	stop_battle_music()
	rooms[room_coordinate] = true
	if is_instance_valid(current_room):
		current_room.heal_room()


func walk_rooms_directory():
	var dir = Directory.new()
	if not dir.open('res://Rooms') == OK:
		print('An error occurred when trying to access the rooms directory')

	dir.list_dir_begin(true)
	var file_name = dir.get_next()
	while not file_name == "":
		if not dir.current_is_dir():
			var string_coord: String = file_name.trim_suffix('.tscn')
			var array_coord := string_coord.split_floats('_')
			var coordinate = Vector2(array_coord[0], array_coord[1])

			rooms[coordinate] = false
		file_name = dir.get_next()


func start_battle_music() -> void:
	$MixingDeskMusic.fade_in('MainTheme', 'Layer3Synth')
	$MixingDeskMusic.fade_in('MainTheme', 'PercussionBass')
	$MixingDeskMusic.fade_in('MainTheme', 'PercussionMetals')
	$MixingDeskMusic.fade_in('MainTheme', 'PercussionSlap')


func stop_battle_music() -> void:
	$MixingDeskMusic.fade_out('MainTheme', 'Layer3Synth')
	$MixingDeskMusic.fade_out('MainTheme', 'PercussionBass')
	$MixingDeskMusic.fade_out('MainTheme', 'PercussionMetals')
	$MixingDeskMusic.fade_out('MainTheme', 'PercussionSlap')

