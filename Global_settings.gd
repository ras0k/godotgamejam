extends Node

signal fps_displayed(value)

func toggle_fullscreen(value):
	OS.window_fullscreen = value
	SavingSettings._Game_Data.fullscreen_on = value
	SavingSettings._save_data()
	
func toggle_vsync(value):
	OS.vsync_enabled = value
	SavingSettings._Game_Data.vsync_on = value
	SavingSettings._save_data()
	
func toggle_fps_display(value):
	emit_signal("fps_displayed", value)
	SavingSettings._Game_Data.display_fps = value
	SavingSettings._save_data()
	
	
func set_max_fps(value):
	Engine.target_fps = value if value < 240 else 0 
	SavingSettings._Game_Data.max_fps = Engine.target_fps if value < 240 else 240
	SavingSettings._save_data()
	
func update_master_vol(vol):
	AudioServer.set_bus_volume_db(0, vol if vol > -50 else AudioServer.set_bus_mute(0, true))
	SavingSettings._Game_Data.master_vol = vol
	SavingSettings._save_data()
	
func update_music_vol(vol):
	AudioServer.set_bus_volume_db(0, vol if vol > -50 else AudioServer.set_bus_mute(0, true))
	SavingSettings._Game_Data.music_vol = vol
	SavingSettings._save_data()
	
func update_sfx_volume(vol):
	AudioServer.set_bus_volume_db(0, vol if vol > -50 else AudioServer.set_bus_mute(0, true))
	SavingSettings._Game_Data.sfx_vol = vol
	SavingSettings._save_data()
	
	
