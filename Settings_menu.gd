extends Popup

#Video Settings
onready var _Display_Option = $Settings_Tabs/Video/MarginContainer/Video_Settings/Display_Opyions
onready var _Vsync = $Settings_Tabs/Video/MarginContainer/Video_Settings/Vsync_Btn
onready var _Display_FPS = $Settings_Tabs/Video/MarginContainer/Video_Settings/Dispaly_fps_Btn
onready var _Max_FPS_Value = $Settings_Tabs/Video/MarginContainer/Video_Settings/HBoxContainer/Max_fps_Val
onready var _Max_FPS_Slider = $Settings_Tabs/Video/MarginContainer/Video_Settings/HBoxContainer/Max_fps_Slider

#Audio Settings
onready var _Master_Vol = $Settings_Tabs/Audio/MarginContainer/Audio_Settings/Master_Vol_Slider
onready var _Music_Vol = $Settings_Tabs/Audio/MarginContainer/Audio_Settings/Music_Vol_Slider
onready var _SFX_Vol = $Settings_Tabs/Audio/MarginContainer/Audio_Settings/SFX_Volume_Slider



func _ready():
	_Display_Option.select(1 if SavingSettings._Game_Data.fullscreen_on else 0)
	GlobalSettings.toggle_fullscreen(SavingSettings._Game_Data.fullscreen_on)
	_Vsync.pressed = SavingSettings._Game_Data.vsync_on
	_Display_FPS.pressed = SavingSettings._Game_Data.display_fps
	_Max_FPS_Slider.value = SavingSettings._Game_Data.max_fps
	
	_Master_Vol.value = SavingSettings._Game_Data.master_vol
	

func _on_Display_Opyions_item_selected(index):
	GlobalSettings.toggle_fullscreen(true if index == 1 else false)


func _on_Vsync_Btn_toggled(button_pressed):
	GlobalSettings.toggle_vsync(button_pressed)


func _on_Dispaly_fps_Btn_toggled(button_pressed):
	GlobalSettings.toggle_fps_display(button_pressed)


func _on_Max_fps_Slid_value_changed(value):
	GlobalSettings.set_max_fps(value)
	_Max_FPS_Value.text = str(value) if value < _Max_FPS_Slider.max_value else "MAX"
	
	
	
#Audio_Settings
	
func _on_Master_Vol_Slider_value_changed(value):
	GlobalSettings.update_master_vol(value)


func _on_Music_Vol_Slider_value_changed(value):
	pass # Replace with function body.


func _on_SFX_Volume_Slider_value_changed(value):
	pass # Replace with function body.



#Exit Buttons
func _on_Button_pressed():
	get_tree().change_scene("res://Menu.tscn")
	
	
func _physics_process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene("res://Menu.tscn")
		
		
		
