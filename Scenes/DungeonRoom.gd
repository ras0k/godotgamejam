extends YSort

class_name DungeonRoom

enum directions { NORTH, SOUTH, EAST, WEST }

var is_open := true setget set_is_open
export var is_cleared := false setget set_is_cleared

signal exit_room(exit_direction)
signal room_cleared


func _ready() -> void:
	for enemy in get_tree().get_nodes_in_group('Enemy'):
		enemy.connect('enemy_dead', self, 'is_room_cleared')
	is_room_cleared()


func is_room_cleared() -> bool:
	if is_cleared:
		true
	yield(get_tree().create_timer(.1), 'timeout')
	if get_tree().get_nodes_in_group('Enemy').empty():
		self.is_open = true
		self.is_cleared = true
		emit_signal('room_cleared')
		return true

	self.is_open = false
	return false


func set_is_cleared(_is_cleared: bool) -> void:
	is_cleared = _is_cleared
	if is_cleared:
		self.is_open = true
		var enemy_parent = get_node_or_null('Enemies')
		if enemy_parent:
			enemy_parent.queue_free()


func heal_room() -> void:
	var prop_heal_delay := .2
	for prop in get_tree().get_nodes_in_group('Prop'):
		prop_heal_delay += .2
		get_tree().create_timer(prop_heal_delay).connect('timeout', prop, 'heal')

	var ground: TileMap = $Ground
	var local_position = ground.to_local(Global.player.position)
	var map_position = ground.world_to_map(local_position)

	ground.set_cellv(map_position, 1)
	var tile_heal_delay = .15
	for radius in 20:
		tile_heal_delay += .15
		for cell_position in ground.get_used_cells():
			if map_position.distance_to(cell_position) < radius:
				get_tree().create_timer(tile_heal_delay).connect('timeout', self, 'heal_tile', [cell_position])


func heal_tile(cell_position: Vector2):
	$Ground.set_cellv(cell_position, 0)


func get_room_enter_position(direction: int) -> Vector2:
	var exit_position: Position2D
	match direction:
		directions.NORTH:
			exit_position = $Portals/PortalNorth/ExitPoint
		directions.SOUTH:
			exit_position = $Portals/PortalSouth/ExitPoint
		directions.EAST:
			exit_position = $Portals/PortalEast/ExitPoint
		directions.WEST:
			exit_position = $Portals/PortalWest/ExitPoint
		_:
			printerr('Direction is not valid: %s' % direction)

	return exit_position.global_position


static func get_opposite_direction(direction: int) -> int:
	var opposite: int
	match direction:
		directions.NORTH:
			opposite = directions.SOUTH
		directions.SOUTH:
			opposite = directions.NORTH
		directions.EAST:
			opposite = directions.WEST
		directions.WEST:
			opposite = directions.EAST
		_:
			printerr('Direction is not valid: %s' % direction)
	return opposite


func set_is_open(_is_open: bool) -> void:
	print('set open %s' % _is_open)
	is_open = _is_open
	for portal in $Portals.get_children():
		portal.is_open = is_open


func set_portal_directions(north: bool, south: bool, east: bool, west: bool) -> void:
	$Portals/PortalNorth.is_enabled = north
	$Portals/PortalSouth.is_enabled = south
	$Portals/PortalEast.is_enabled = east
	$Portals/PortalWest.is_enabled = west


func _on_Portal_body_entered(body: Node, direction: int) -> void:
	if body is Player:
		emit_signal('exit_room', direction)


func _on_PortalNorth_body_entered(body: Node) -> void:
	_on_Portal_body_entered(body, directions.NORTH)


func _on_PortalSouth_body_entered(body: Node) -> void:
		_on_Portal_body_entered(body, directions.SOUTH)


func _on_PortalEast_body_entered(body: Node) -> void:
		_on_Portal_body_entered(body, directions.EAST)


func _on_PortalWest_body_entered(body: Node) -> void:
		_on_Portal_body_entered(body, directions.WEST)
