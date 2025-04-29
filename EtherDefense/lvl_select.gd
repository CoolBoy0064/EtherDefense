extends Control


func _on_level_1_pressed() -> void:
	$Scene_Transition.show()
	$Scene_Transition/Transition.play("fade_out")
	await $Scene_Transition/Transition.animation_finished
	get_tree().change_scene_to_file("res://Level1.tscn")

func _on_level_2_pressed() -> void:
	$Scene_Transition.show()
	$Scene_Transition/Transition.play("fade_out")
	await $Scene_Transition/Transition.animation_finished
	get_tree().change_scene_to_file("res://OceanBaseLvl.tscn") # Replace with function body.
	
func grab():
	$"VBoxContainer/Level 1".grab_focus()
