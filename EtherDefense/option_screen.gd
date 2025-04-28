extends Control


signal exited


func _on_back_pressed() -> void:
	emit_signal("exited")
	
	

func _on_option_button_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		2: 
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
				
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
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"),linear_to_db(value))
	
	
func _on_button_pressed() -> void:
	$VBoxContainer.hide()
	$Menu.show()


func _on_menu_back() -> void:
	$Menu.hide()
	$VBoxContainer.show()
