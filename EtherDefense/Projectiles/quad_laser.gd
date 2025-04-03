extends Area2D


@export var speed = 100
@export var damage = 10
@export var explosion : PackedScene

var direction = Vector2.ZERO



func _physics_process(delta: float) -> void:
	if direction != Vector2.ZERO:
		
		translate(direction * speed * delta)


func set_damage(dama):
	damage = dama
	
func set_direction(direct: Vector2):
	direction = direct

func handle_shield():
	explode()

func explode():
	call_deferred("enable_explosion")
	$Sprite2D.hide()
	$QuadLaserExplosion.emitting = true
	$free_timer.start(.5)

func _on_explosion_zone_body_entered(body: Node2D) -> void:
	print("saw an enemy")
	if (body.has_method("handle_hit")):
		print("damaging")
		body.handle_hit(damage)


func enable_explosion():
	$explosion_zone/CollisionShape2D.disabled = false
func _on_free_timer_timeout() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	explode()


func _on_ready() -> void:
	print("quad laser ready")
