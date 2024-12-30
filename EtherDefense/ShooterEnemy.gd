extends Actor

var shooting = 0
var shootCooldown = 0
var enemies = 0
var current_enemy
var next_enemy 
var lookLeft = 1
var direction = -1
var wall = 0
var iFrames = 0
@onready var sprite : Sprite2D = get_node("Sprite2D")
@onready var HPBar = $HealthBar
@export var Bullet: PackedScene


@onready var gun = $Gun
@onready var gun2 = $Gun2
@onready var detector = $Area2D/CollisionShape2D


func _physics_process(delta: float) -> void:
	if shooting:
		if shootCooldown <= 0:
			shoot()
			shootCooldown = 60
		shootCooldown -= 1
	
	if iFrames > 0:
		iFrames += 1
		if iFrames > 15:
			iFrames = 0
	
	
	velocity.x = speed.x * direction
	
	velocity.y += gravity * delta
	
	if velocity.x < 0:
		sprite.flip_h = false
	elif velocity.x > 0:
		sprite.flip_h = true
		
		
	if is_on_wall() && wall == 0:
		wall = 1
		direction *= -1
	elif !is_on_wall():
		wall = 0
		
		
	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	move_and_slide()
	velocity.y = velocity.y
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Area2D_body_entered(body: Node) -> void:
	shooting = 1

func shoot():
	var bullet_instance = Bullet.instantiate()
	get_tree().get_root().add_child(bullet_instance)
	var dir = Vector2()
	dir.y = 0
	if !lookLeft:
		bullet_instance.global_position = gun2.global_position
		dir.x = 1
	elif lookLeft:
		dir.x = -1
		bullet_instance.global_position = gun.global_position
	bullet_instance.direction = dir
	bullet_instance.set_damage(3)


func new_target():
	if enemies == 0:
		shooting = 0
	else:
		current_enemy = next_enemy
		
func handle_hit(Dablege):
	if iFrames == 0:
		Health -= Dablege
		iFrames += 1
		HPBar.value = Health
		if Health <= 0:
			emit_signal("died")
			queue_free()
