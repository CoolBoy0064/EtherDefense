extends CharacterBody2D

signal Turret_Shot(bullet, position, direction, damage)


@export var speed = Vector2(0, 0)
@export var gravity = 1600
@export var Health = 50
@export var damage = 0
@export var start_scale = 1 #if set to -1 the turret will start fliped
@export var MAX_HEALTH = 50
var shooting = 0
var shootCooldown = 0
var enemies = 0
var target = Vector2()
var current_enemy
var next_enemy 
var lookleft = 0


@export var Bullet: PackedScene


@onready var gun = $Gun
@onready var detector = $Area2D/CollisionShape2D

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if start_scale == -1:
		flip_tower()

func _physics_process(delta: float) -> void:
	if shooting:
		if shootCooldown <= 0:
			shoot()
			shootCooldown = 60
		shootCooldown -= 1
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Area2D_body_entered(body: Node) -> void:
	if !shooting:
		current_enemy = body
		body.connect("died", Callable(self, "new_target"))
	else:
		next_enemy = body
		body.connect("died", Callable(self, "new_target"))
	shooting = 1
	enemies += 1
	target = body.global_position
	print (enemies)

func shoot():
	if (!is_instance_valid(current_enemy)):
		return #do nothing if the enemy were shooting does not exist
	var bullet_instance = Bullet.instantiate()
	get_tree().get_root().add_child(bullet_instance)
	bullet_instance.global_position = gun.global_position
	var dir = (current_enemy.global_position - gun.global_position).normalized()
	if dir.x < 0 and !lookleft:
		scale.x = -1
		lookleft = 1
	elif dir.x > 0 and lookleft:
		scale.x = -1
		lookleft = 0
	bullet_instance.direction = dir
	bullet_instance.set_damage(25)
	

func handle_hit(damage):
	Health = Health - damage
	$HealthBar.value = (Health / float(MAX_HEALTH)) * 100
	if(Health <= 0):
		destroy()

func destroy():
	queue_free()

func _on_Area2D_body_exited(body: Node) -> void:
	enemies -= 1
	print (enemies)
	if enemies == 0:
		shooting = 0

func new_target():
	if enemies == 0:
		shooting = 0
	else:
		current_enemy = next_enemy
		
func flip_tower():
	if scale.x == 1:
		scale.x = -1
		$HealthBar.scale.x = $HealthBar.scale.x * -1
		$HealthBar.position.x = $HealthBar.position.x * -1
		lookleft = true
	else:
		scale.x = 1
		$HealthBar.scale.x = $HealthBar.scale.x * -1
		$HealthBar.position.x = $HealthBar.position.x * -1
		lookleft = false
	
