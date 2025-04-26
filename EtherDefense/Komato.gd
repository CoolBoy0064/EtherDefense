extends CharacterBody2D


@export var speed = Vector2(200, 0)
@export var starting_direction = -1 #affects the starting direction the enemy will go (-1 for left, 1 for right)
@export var damage = 10
@export var MAX_HEALTH = 55
var health = 55
var target_location
var target_found = false
var direction = -1
var stop_timer = 1 #how much time (in seconds) until the komato stops when it hits the gem
var active_timer = false

func _ready():
	health = MAX_HEALTH
	if(starting_direction == 1):
		change_direction()

func _physics_process(delta: float) -> void:
	if(target_found && stop_timer > 0):
		velocity = Vector2.RIGHT.rotated(get_angle_to(target_location)) * speed
		move_and_slide()
		if active_timer:
			stop_timer -= delta
		return
	elif(target_found):
		$AnimationPlayer.play("Attack")
		speed.x = 0
		speed.y = 0
		return
		
	if !target_found:
		#this if statement will help the komato avoid getting stuck on walls
		#!!!This is intended as a fire extinguisher not a fullprooof method!!!
		#In general the komato should only spawn in higher up places
		if $wall_detector.is_colliding(): #if we are about to hit a wall
			speed.y = 200 #if were about to hit a wall, move under it.
		elif $Ceiling_detector.is_colliding() && speed.y < 0: #if we are not about to hit a wall and we are about to hit a ceiling, stop
			speed.y = 0 #If we are about to move into a ceiling stop.
		elif $floor_detector/floor_detector_2.is_colliding(): #if we are too close to the floor
			speed.y = -200
		elif !$floor_detector.is_colliding(): #if we are not about to hit a wall and we are not about to hit a ceiling and we are too far from the floor, move down
			speed.y = 200
		elif $floor_detector.is_colliding(): #if none of the above and we are a proper distance from the floor stop
			speed.y = 0
			
		velocity.x = speed.x * direction
		velocity.y = speed.y
		move_and_slide()


func _on_gem_detector_body_entered(body: Node2D) -> void:
	if body.has_method("is_a_gem"):
		print("gem found")
		speed.y = 200
		target_location = body.global_position
		target_location.y += -125
		target_found = true
		return

func change_direction():
	$wall_detector.target_position.x = $wall_detector.target_position.x * -1
	if direction == -1:
		$AnimatedSprite2D.flip_h = 1
		direction = 1
	else:
		$AnimatedSprite2D.flip_h = -1
		direction = -1


func _on_damage_area_body_entered(body: Node2D) -> void:
	if body.has_method("is_a_gem"):
		active_timer = true
	if body.has_method("handle_hit"):
		body.handle_hit(damage)
		
func handle_hit(damage):
	health -= damage
	$HealthBar.value = (health / float(MAX_HEALTH)) * 100
	if health <= 0:
		die()
		

func die():
	queue_free()
