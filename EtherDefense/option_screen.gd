extends Control


signal exited

@onready var fullscreen = $VBoxContainer/Window
@onready var master_volume = $VBoxContainer/HSlider

func _ready():
	var video_settings = UserPreferences.load_video_settings()
	fullscreen.select(video_settings.fullscreen)
	print(video_settings.fullscreen)
	match video_settings.fullscreen:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		2: 
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
	var audio_settings = UserPreferences.load_audio_settings()
	master_volume.value = min(audio_settings.master_volume, 1.0) * 100
	if (master_volume.value == 0):
		AudioServer.set_bus_mute(0, 1)

func _on_back_pressed() -> void:
	emit_signal("exited")
	
	

func _on_option_button_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			UserPreferences.save_video_setting("fullscreen", 0)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
			UserPreferences.save_video_setting("fullscreen", 1)
		2: 
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			UserPreferences.save_video_setting("fullscreen", 2)
				
#func _on_option_button_item_selected(index: int) -> void:
	#var resolutions := {
		#"1920 x 1080": Vector2i(1920, 1080),
		#"1280 x 720": Vector2i(1280, 720),
		#"1152 x 648": Vector2i(1152, 648)
	#}
	#var keys = resolutions.keys()
	#if index >= 0 and index < keys.size():
		#var resolution = resolutions[keys[index]]
		#DisplayServer.window_set_size(resolution)

func _on_h_slider_value_changed(value: float) -> void:
	print(value)
	UserPreferences.save_audio_setting("master_volume", value / 100)
	if (value == 0):
		AudioServer.set_bus_mute(0, 1)
		return
	else:
		AudioServer.set_bus_mute(0, 0)
	var volume_change = value/10
	AudioServer.set_bus_volume_db(0, volume_change)
	

	
	
func _on_button_pressed() -> void:
	$VBoxContainer.hide()
	$Menu.show()


func _on_menu_back() -> void:
	$Menu.hide()
	$VBoxContainer.show()
