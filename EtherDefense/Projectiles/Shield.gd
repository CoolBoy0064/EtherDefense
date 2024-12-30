extends Area2D

signal shieldDied()

@export var speed = 1000
@export var damage = 1
var time = 0

var direction = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if direction != Vector2.ZERO:
		
		translate(direction * speed * delta)
	if time == 20:
		direction.x *= -1
		direction.y = -1
	elif time == 30:
		direction.y = 1
	elif time == 40:
		emit_signal("shieldDied")
		queue_free()
	time += 1



func set_damage(dama):
	damage = dama
	
func set_direction(direct: Vector2):
	direction = direct



func _on_Shield_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	if body.has_method("handle_hit"):
		body.handle_hit(damage)
