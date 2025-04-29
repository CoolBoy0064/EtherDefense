extends Control

@export var lvlone : PackedScene
@export var lvltwo : PackedScene

func _on_level_1_pressed() -> void:
	$Scene_Transition.show()
	$Scene_Transition/Transition.play("fade_out")
	await $Scene_Transition/Transition.animation_finished
	get_tree().change_scene_to_packed(lvlone)

func _on_level_2_pressed() -> void:
	$Scene_Transition.show()
	$Scene_Transition/Transition.play("fade_out")
	await $Scene_Transition/Transition.animation_finished
	get_tree().change_scene_to_packed(lvltwo) # Replace with function body.
	
func grab():
	$"VBoxContainer/Level 1".grab_focus()
