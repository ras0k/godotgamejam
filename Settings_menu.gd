extends Popup

#Video Settings
onready var _Display_Option = $Settings_Tabs/Video/MarginContainer/Video_Settings/Display_Opyions
onready var _Vsync = $Settings_Tabs/Video/MarginContainer/Video_Settings/Vsync_Btn
onready var _Display_FPS = $Settings_Tabs/Video/MarginContainer/Video_Settings/Dispaly_fps_Btn
onready var _Max_FPS_Value = $Settings_Tabs/Video/MarginContainer/Video_Settings/Max_fps_Val

#Audio Settings
onready var _Master_Vol = $Settings_Tabs/Audio/MarginContainer/Audio_Settings/Master_Vol_Slider
onready var _Music_Vol = $Settings_Tabs/Audio/MarginContainer/Audio_Settings/Music_Vol_Slider
onready var _SFX_Vol = $Settings_Tabs/Audio/MarginContainer/Audio_Settings/SFX_Volume_Slider



func _ready():
	popup()

func _on_Display_Opyions_item_selected(index):
	GlobalSettings.toggle_fullscreen(true if index == 1 else false)


func _on_Vsync_Btn_toggled(button_pressed):
	GlobalSettings.toggle_vsync(button_pressed)


func _on_Dispaly_fps_Btn_toggled(button_pressed):
	GlobalSettings.toggle_fps_display(button_pressed)


func _on_Max_fps_Slid_value_changed(value):
	GlobalSettings.set_max_fps(value)
	#max_fps_value.text = str(value) if value < max_fps_slider.max_value else "max"
	
	
#Audio_Settings
	
func _on_Master_Vol_Slider_value_changed(value):
	pass # Replace with function body.


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
