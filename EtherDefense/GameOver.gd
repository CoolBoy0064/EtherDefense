extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
func game_over():
	$VBoxContainer/TryAgain.grab_focus()


func _on_try_again_pressed():
	$Scene_Transition/Transition.play("fade_out")
	await $Scene_Transition/Transition.animation_finished
	get_tree().reload_current_scene()

func _on_returnto_title_pressed():
	$Scene_Transition/Transition.play("fade_out")
	await $Scene_Transition/Transition.animation_finished
	get_tree().change_scene_to_file("res://Title Screen.tscn") # Replace with function body.
