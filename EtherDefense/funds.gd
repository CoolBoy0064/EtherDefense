extends Area2D

@export var value = 10 

func _on_body_entered(body: Node2D) -> void:
	if(body.has_method("add_funds")):
		print("adding funds")
		body.add_funds(value)
		queue_free()
