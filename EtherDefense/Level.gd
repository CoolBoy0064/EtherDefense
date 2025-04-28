extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Scene_Transition/Transition.play("fade_in")
