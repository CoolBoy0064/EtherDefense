extends Area2D


@export var speed = 500
@export var damage = 1

var direction = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if direction != Vector2.ZERO:
		
		translate(direction * speed * delta)


func set_damage(dama):
	damage = dama
	
func set_direction(direct: Vector2):
	direction = direct

func _on_Boolet_body_entered(body: Node) -> void:
	if body.has_method("handle_hit"):
		body.handle_hit(damage)
	queue_free()

func handle_shield():
	queue_free()
