extends Area2D

export(String, FILE) var next_level = ""
#currently the next_level must be manually selected in the inspector after placing Portal.tscn in a scene tree
export(Vector2) var next_level_spawn_point
# north exits, spawn should be x 515 y 520
# south exits, spawn should be x 515 y 100
# trying to find a way to set these using Position2D node - please feel free to contact bran2 on discord
# with suggestions or ideas.

var player = null

func _find_player_node():
	player = get_parent().find_node("Player")

func _set_next_spawn():
	Global.player_spawn_point = next_level_spawn_point

func _ready():
	_find_player_node()

func _on_Portal_body_entered(body):
	_set_next_spawn()
	if body == player:
		get_tree().change_scene(next_level)
