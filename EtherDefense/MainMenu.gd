extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


func _ready() -> void:
	$VBoxContainer/LvlSelect.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass



func _on_QuitButton_pressed() -> void:
	get_tree().quit()


func _on_lvl_select_pressed() -> void:
	$VBoxContainer.hide()
	$Label.hide()
	$Control.show()
	$Timer.start(.5)
	await $Timer.timeout
	$Control.grab()


func _on_menu_exited() -> void:
	$Options.hide()
	$VBoxContainer.show()
	$VBoxContainer/LvlSelect.grab_focus()


func _on_button_pressed() -> void:
	$VBoxContainer.hide()
	$Options.show()
	$Options.grab()


func _on_how_to_play_pressed() -> void:
	$Tutorial.show()
	$Tutorial/Closing.grab_focus()
	$VBoxContainer.hide()
	$how_to_play.hide()


func _on_closing_pressed() -> void:
	$Tutorial.hide()
	$VBoxContainer.show()
	$VBoxContainer/LvlSelect.grab_focus()
	$how_to_play.show()
