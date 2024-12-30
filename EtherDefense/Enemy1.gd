extends CharacterBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal died()

@export var speed = Vector2(200, 1000)
@export var gravity = 1600
@export var Health = 50
@export var damage = 0
var direction = -1
var wall = 0
var iFrames = 0
@onready var sprite : Sprite2D = get_node("Sprite2D")
@onready var HPBar = $HealthBar

func _physics_process(delta):
	
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
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_PlayerDetector_body_entered(body: Actor) -> void:
	Health -= body.get_Damage()
	
	if Health <= 0:
		queue_free()

func handle_hit(dmg):
	if iFrames == 0:
		Health -= dmg
		iFrames += 1
		HPBar.value = Health
		if Health <= 0:
			emit_signal("died")
			queue_free()
