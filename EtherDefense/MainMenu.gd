extends Control





func _on_NewGameButton_pressed() -> void:
	get_tree().change_scene_to_file("res://Level1.tscn")
	
func _on_QuitButton_pressed() -> void:
	get_tree().quit()


func _on_lvl_select_pressed() -> void:
	get_tree().change_scene_to_file("res://LvlSelect.tscn")


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Option Screen.tscn")
###hello 
