extends Area2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
		
func is_shield():
	return 1



func _on_UpShield_area_entered(area: Area2D) -> void:
	if area.has_method("handle_shield"):
		area.handle_shield()
