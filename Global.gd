extends Node

export(Vector2) var player_spawn_point = Vector2(240, 160)
export var global_player_max_health = 100
var global_player_health = global_player_max_health

#calling this function when a player takes damage. Seems to work, but player health is reset when new scene is loaded
func _update_player_health(damage):
	global_player_health = global_player_health - 5
	print("Global Health Changed" + str(global_player_health))#debug
