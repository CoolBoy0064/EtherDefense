extends CharacterBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal died()

@export var speed = Vector2(200, 1000)
@export var gravity = 1600
@export var Health = 50
@export var damage = 10
var attackSpeed = 1 #time in seconds this creature will take to finish its attack animation
var attackInterval = 1 #time that has elapsed since the last attack 
var direction = -1
var wall = 0
var iFrames = 0
var stop = false;
var collision = false #Tracks if a collision has occured on the hurtbox
@onready var HPBar = $HealthBar

func _physics_process(delta):
	
	if iFrames > 0:
		iFrames += 1
		if iFrames > 15:
			iFrames = 0
	
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
		if(attackInterval > attackSpeed && collision):
			$AnimationPlayer.play("attack")
			attackInterval = 0
			collision = false
		elif(attackInterval > attackSpeed && !collision):
			stop = false #if we did not encounter a new collision after the previous animation, continue moving
		attackInterval += delta
		
		
		
	
# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D/CollisionShape2D.disabled = false

func handle_hit(dmg):
	if iFrames == 0:
		Health -= dmg
		iFrames += 1
		HPBar.value = Health
		if Health <= 0:
			emit_signal("died")
			queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("handle_hit"):
		body.handle_hit(damage)
	stop = true
	print("stopped")
	collision = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if(!$Area2D/CollisionShape2D.disabled):
		stop = false
		collision = false
