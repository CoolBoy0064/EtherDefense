extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass



func _on_QuitButton_pressed() -> void:
	get_tree().quit()


func _on_lvl_select_pressed() -> void:
	$VBoxContainer.hide()
	$Label.hide()
	$Control.show()


func _on_menu_exited() -> void:
	$Options.hide()
	$VBoxContainer.show()


func _on_button_pressed() -> void:
	$VBoxContainer.hide()
	$Options.show()
