extends Node

signal fps_displayed(value)
signal fov_apdate(value)

func toggle_fullscreen(value):
	OS.window_fullscreen = value
	
func toggle_vsync(value):
	OS.vsync_enabled = value
	
func toggle_fps_display(value):
	emit_signal("fps_displayed", value)

func set_max_fps(value):
	Engine.target_fps = value if value < 240 else 0 
	
	
	
func update_master_vol(vol):
	AudioServer.set_bus_volume_db(0, vol)
	
func update_fov(value):
	emit_signal("fov_apdate", value)
