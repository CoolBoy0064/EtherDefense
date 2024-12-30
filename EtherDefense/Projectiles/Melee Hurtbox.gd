extends Area2D

@export var damage = 1

var timer = 15

var direction = Vector2.ZERO


func _physics_process(delta: float) -> void:
	if timer <= 0:
		queue_free()
	else:
		timer -= 1

func set_damage(dama):
	damage = dama
	
func set_direction(direct: Vector2):
	direction = direct
	


func _on_Hitbox_body_entered(body: Node) -> void:
	if body.has_method("handle_hit"):
		body.handle_hit(damage)
