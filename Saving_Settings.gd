extends Node

const _Save_File = "user://_Save_File.save"

var _Game_Data = {}

func _ready():
	_load_data()
	print("data loaded")
	print(_Game_Data)


func _load_data():
	var file = File.new()
	if not file.file_exists(_Save_File):
		_Game_Data = {
			"fullscreen_on": false,
			"vsync_on": false,
			"display_fps": false,
			"max_fps": 0,
			"master_vol": .5,
			"music_vol": .5,
			"sfx_vol": .5,
		}
		_save_data()
	file.open(_Save_File, File.READ)
	_Game_Data = file.get_var()
	file.close()

func _save_data():
	var file = File.new()
	file.open(_Save_File, File.WRITE)
	file.store_var(_Game_Data)
	file.close()
