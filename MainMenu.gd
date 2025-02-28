extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_NewGameButton_pressed() -> void:
	get_tree().change_scene_to_file("res://Level1.tscn")


func _on_QuitButton_pressed() -> void:
	get_tree().quit()


func _on_lvl_select_pressed() -> void:
	get_tree().change_scene_to_file("res://LvlSelect.tscn")
