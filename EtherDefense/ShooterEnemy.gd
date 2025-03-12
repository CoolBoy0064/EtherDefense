extends Actor

signal died

var shooting = 0
var shootCooldown = 0
var enemies = 0
var current_enemy
var next_enemy 
var lookLeft = 1
var direction = -1
var wall = 0
var stop = false;
@export var drop : PackedScene
@export var drop_count = 1
@export var starting_direction = 1
@onready var sprite : Sprite2D = get_node("Sprite2D")
@onready var HPBar = $HealthBar
@export var Bullet: PackedScene


@onready var gun = $Gun
@onready var gun2 = $Gun2
@onready var detector = $Area2D/CollisionShape2D

func _ready() -> void:
	apply_floor_snap()
	if starting_direction != 1:
		change_direction()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if shooting:
		if shootCooldown <= 0:
			shoot()
			shootCooldown = 60
		shootCooldown -= 1

	if(!stop):
	
	
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
	else:
		velocity.x = 0
		velocity.y += gravity * delta
		set_velocity(velocity)
		set_up_direction(Vector2.UP)
		move_and_slide()


func _on_Area2D_body_entered(body: Node) -> void:
	shooting = 1
	stop = true
	enemies = enemies + 1

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
	Health -= Dablege
	HPBar.value = (Health / float(MAX_HEALTH)) * 100
	if Health <= 0:
		emit_signal("died")
		destroy()


func _on_area_2d_body_exited(body: Node2D) -> void:
	enemies = enemies - 1
	if enemies <= 0:
		shooting = 0
		stop = false
		if enemies < 0:
			enemies = 0 #fail safe, enemies should never be negative
			
func change_direction():
	direction = direction * -1
	lookLeft = !lookLeft
	$Area2D/CollisionShape2D.position.x = $Area2D/CollisionShape2D.position.x * -1
	
func destroy():
	for xn in drop_count:
		call_deferred("create_drop", xn)
	queue_free()

#ISSUE: drops get created slightly in the ground for the enemy that uses this files, will probably hardcode position later
func create_drop(xn):
		var drop_instance = drop.instantiate()
		get_tree().get_root().add_child(drop_instance)
		drop_instance.global_position = global_position
		drop_instance.global_position.x = drop_instance.global_position.x + (xn * 20)
