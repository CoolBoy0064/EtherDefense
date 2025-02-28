extends CharacterBody2D

signal Turret_Shot(bullet, position, direction, damage)

@export var speed = Vector2(0, 0)
@export var gravity = 1600
@export var Health = 50
@export var damage = 0
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
	print (gun.global_position)
	print (global_position)

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
	bullet_instance.set_damage(10)
	


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
