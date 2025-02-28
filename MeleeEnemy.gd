extends CharacterBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal died()

const flip_x = Vector2(-1, 0)

@export var starting_direction = -1 #affects the starting direction the enemy will go (-1 for left, 1 for right)
@export var speed = Vector2(200, 1000)
@export var gravity = 1600
@export var Health = 50
@export var MAX_HEALTH = 50
@export var damage = 10
@export var attackSpeed = 1 #time in seconds this creature will take to finish its attack animation
var attackInterval = 1 #time that has elapsed since the last attack 
var direction = -1
var wall = 0
var stop = false;
var collision = false #Tracks if a collision has occured on the hurtbox
@onready var HPBar = $HealthBar

# Called when the node enters the scene tree for the first time.
func _ready():
	if starting_direction != -1:
		change_direction()
	$Area2D/CollisionShape2D.disabled = false
	attackInterval = attackSpeed

func _physics_process(delta):
	
	
	if(!stop):
		$AnimatedSprite2D.play("default")
		velocity.x = speed.x * direction
	
		velocity.y += gravity * delta
	
		if velocity.x < 0:
			$AnimatedSprite2D.flip_h = false
		elif velocity.x > 0:
			$AnimatedSprite2D.flip_h = true
		
		
		if is_on_wall() && wall == 0:
			wall = 1
			velocity.y = -velocity.x
		elif !is_on_wall():
			wall = 0
		
		
		set_velocity(velocity)
		set_up_direction(Vector2.UP)
		move_and_slide()
		velocity.y = velocity.y
	else:
		if(attackInterval > attackSpeed && collision && !$AnimationPlayer.is_playing()):
			$AnimationPlayer.play("attack")
			attackInterval = 0
			collision = false
		elif(attackInterval > attackSpeed && !collision && !$AnimationPlayer.is_playing()):
			stop = false #if we did not encounter a new collision after the previous animation, continue moving
		attackInterval += delta
		velocity.x = 0
		velocity.y += gravity * delta
		set_velocity(velocity)
		set_up_direction(Vector2.UP)
		move_and_slide()
		
		
		


func handle_hit(dmg):
	Health -= dmg
	HPBar.value = (Health / float(MAX_HEALTH)) * 100
	if Health <= 0:
		emit_signal("died")
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("handle_hit"):
		body.handle_hit(damage)
	stop = true
	collision = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if(!$Area2D/CollisionShape2D.disabled):
		stop = false
		collision = false
		
func change_direction():
	var current_position = $Area2D/CollisionShape2D.get_position()
	$Area2D/CollisionShape2D.set_position(current_position * flip_x)
	if direction == -1:
		direction = 1
	else:
		direction = -1
