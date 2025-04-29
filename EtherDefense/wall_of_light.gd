extends CharacterBody2D

@export var gravity = 1600
@export var Health = 100
@export var MAX_HEALTH = 100
@export var start_scale = 1 #set to -1 to start flipped

func _ready() -> void:
	if start_scale == -1:
		flip_tower()
	apply_floor_snap()

func handle_hit(damage):
	Health = Health - damage
	$HealthBar.value = (Health / float(MAX_HEALTH)) * 100
	if(Health <= 0):
		destroy()
	
	
	
func _physics_process(delta):
	velocity.y += gravity * delta
	velocity.x = 0
	move_and_slide()

# Add code for the tower to explode later
func destroy():
	queue_free()

func flip_tower():
	if scale.x == 1:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
