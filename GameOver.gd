extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _on_try_again_pressed():
	get_tree().change_scene_to_file("res://Level1.tscn")

func _on_returnto_title_pressed():
	get_tree().change_scene_to_file("res://Title Screen.tscn") # Replace with function body.
