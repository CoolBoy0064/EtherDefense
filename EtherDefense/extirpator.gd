extends CharacterBody2D


@export var movement_speed = Vector2(200,0)
@export var gravity = 1600
@export var attackSpeed = 1
@export var Bullet : PackedScene
@export var melee_damage = 3
var shootCooldown = 1 #time in seconds it will take this enemy to shoot
var targets = []
var melee = false
var shooting = false
var speed = movement_speed
var lookLeft = true #tracks whether the extirp is looking left
var attackInterval = 1 #time that has elapsed since the last attack 
var direction = -1
var wall = 0
var stop = false;
var collision = false #Tracks if a collision has occured on the hurtbox

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _physics_process(delta: float) -> void:
	if shooting:
		if shootCooldown <= 0:
			print("shooting")
			shoot()
			shootCooldown = 1
		shootCooldown -= delta

	if(!stop):
	
	
		velocity.x = speed.x * direction
	
		velocity.y += gravity * delta
	
		if velocity.x < 0:
			$AnimatedSprite2D.flip_h = false
		elif velocity.x > 0:
			$AnimatedSprite2D.flip_h = true
		
		
		set_velocity(velocity)
		set_up_direction(Vector2.UP)
		move_and_slide()
		velocity.y = velocity.y
	else:
		if(melee):
			$AnimationPlayer.play("Melee_attack")
		velocity.x = 0
		velocity.y += gravity * delta
		set_velocity(velocity)
		set_up_direction(Vector2.UP)
		move_and_slide()


func shoot():
	var bullet_instance = Bullet.instantiate()
	get_tree().get_root().add_child(bullet_instance)
	var dir = Vector2()
	dir.y = 0
	if len(targets) > 0 && lookLeft:
		dir = Vector2.RIGHT.rotated(get_angle_to(targets[0].global_position))
		bullet_instance.global_position = $Gun.global_position
	elif len(targets) > 0 && lookLeft:
		dir = Vector2.RIGHT.rotated(get_angle_to(targets[0].global_position))
		bullet_instance.global_position = $Gun2.global_position
	elif !lookLeft:
		bullet_instance.global_position = $Gun2.global_position
		dir.x = 1
	elif lookLeft:
		dir.x = -1
		bullet_instance.global_position = $Gun.global_position
	bullet_instance.direction = dir
	bullet_instance.set_damage(3)
	print(bullet_instance)


func _on_shooting_range_body_entered(body: Node2D) -> void:
	targets.append(body)
	if(!melee):
		print("stopping")
		stop = true
		shooting = true
	
		
#func handle_hit(Dablege):
#	Health -= Dablege
#	HPBar.value = (Health / float(MAX_HEALTH)) * 100
#	if Health <= 0:
#		emit_signal("died")
#		destroy()
	
			
func change_direction():
	direction = direction * -1
	lookLeft = !lookLeft
	$"Shooting Range".scale = $"Shooting Range".scale * -1
	


func _on_shooting_range_body_exited(body: Node2D) -> void:
	print(len(targets))
	targets.erase(body)
	print(len(targets))
	if len(targets) <= 0:
		shooting = false
		if !melee:
			stop = false


func _on_melee_range_body_entered(body: Node2D) -> void:
	melee = true
	shooting = false
	stop = true


func _on_melee_damage_body_entered(body: Node2D) -> void:
	if body.has_method("handle_hit"):
		body.handle_hit(melee_damage)
		
func test():
	print("animation playing")
