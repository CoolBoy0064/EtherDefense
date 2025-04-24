extends CharacterBody2D
class_name Player


signal gunFired(bullet, position, direction)


@export var speed = Vector2(200, 1000)
@export var gravity = 1500
@export var Health = 50
@export var damage = 0
@export var MAX_HEALTH = 50
@export var respawn_timer = 10 #time in seconds the player will remain dead
var respawn_time = 0
var jumpForce : int = 700
var isDashing = 0
var wallJump = 0
var wallJumpT = 0
var is_jump_interrupted = 0
var iFrames = 0
var direction = Vector2()
var lookLeft = 0
var currentWeapon = 1
var shieldActive = 0
var isShieldUp = false
var landing = false
var shieldUpInstance
var dead = false
var attacking = false
var walking = false
var spawn_position
@export var Bullet: PackedScene
@export var Melee: PackedScene
@export var Shield: PackedScene
@export var ShieldUp: PackedScene
@export var ghost: PackedScene
@export var dust: PackedScene


@onready var gun = $PkmnGUN
@onready var gun2 = $PkmnGUN2
@onready var HPBar = $HealthBar
		
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") and !isShieldUp:
		if !is_on_floor():
			$AnimationPlayer.play("Jump_swing")
		else:
			if !isDashing:
				$AnimationPlayer.play("swing")
			else:
				$AnimationPlayer.play("dash_swing")
		attacking = true
	if event.is_action_pressed("Secondary") and !isShieldUp:
		if(currentWeapon == 1):
			if isDashing:
				$AnimationPlayer.play("dash_shoot")
			else:
				$AnimationPlayer.play("Shoot")
		elif currentWeapon == 2  and !shieldActive:
			$AnimationPlayer.play("holding_shield")
		attacking = true
	if event.is_action_pressed("Switch") and !isShieldUp:
		if(currentWeapon == 1): #If weapon is the gun, switch to shield
			currentWeapon = 2
			print ("Weapon is Shield")
		elif currentWeapon == 2: #If weapon is shield, switch to gun
			currentWeapon = 1
			print ("weapon is gun")
		update_HUD()
	if event.is_action_released("Secondary") and isShieldUp:
		isShieldUp = false
		$AnimationPlayer.play("Shield_Throw")
	if event.is_action_pressed("ui_pause"):
		get_tree().change_scene_to_file("res://Title Screen.tscn")
	if event.is_action_pressed("spawn_tower"):
		$Build_Menu.show()
		
	

func _physics_process(delta):
	
	#Jumping and gravity
	if (!dead):
		if Input.is_action_just_pressed("jump") and is_on_wall() and !shieldActive and !is_on_floor() and !wallJump:
			if Input.is_action_pressed("dash"):
				isDashing = 1
			wallJump = 1
			direction.x = -direction.x
		is_jump_interrupted = Input.is_action_just_released("jump") and velocity.y < 0
		direction = get_direction(wallJump)
		velocity = calculate_move_velocity(velocity,direction, speed, is_jump_interrupted, wallJump)
		set_velocity(velocity)
		move_and_slide()
		velocity = velocity
	
		if wallJump:
			wallJumpT += 1
			if wallJumpT == 12:
				wallJump = 0
				wallJumpT = 0
			
		if iFrames > 0:
			iFrames += 1
			if iFrames % 10 == 0 and iFrames % 20 != 0:
				$Sprite.hide()
			elif iFrames % 20 == 0:
				$Sprite.show()
			if iFrames > 60:
				iFrames = 0
				$Sprite.show()
	else:
		respawn_time = respawn_time + delta
		$RespawnTimer.text = str(round(10 - respawn_time))
		if (respawn_time >= respawn_timer):
			respawn_time = 0
			respawn()
			
	
	
	
	
	if velocity.x > 0 and lookLeft and !isShieldUp and !wallJump:
		$Sprite.flip_h = false
		lookLeft = 0
		
	elif velocity.x < 0 and !lookLeft and !isShieldUp and !wallJump:
		$Sprite.flip_h = true
		lookLeft = 1
	



# Called when the node enters the scene tree for the first time.
func _ready():
	update_HUD()
	spawn_position = global_position
	HPBar.max_value = MAX_HEALTH
	$AnimationPlayer.get_animation("walk").loop = true


func get_direction(wallJump: bool) -> Vector2:
	var jumping
	var movement_direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	if Input.is_action_just_pressed("jump") and is_on_floor() or Input.is_action_just_pressed("jump") and is_on_wall():
		if !attacking:
			$Sprite.play("Jumping")
		jumping = -1
	elif is_on_floor():
		jumping = 0
		if $Sprite.animation == "falling" && !attacking:
			$AnimationPlayer.play("landing")
			landing = true
	else:
		jumping = 1
		if !attacking && $Sprite.animation != "falling":
			$Sprite.play("falling") 
	if wallJump:
		movement_direction = direction.x
	if movement_direction == 0 && jumping == 0 && is_on_floor() && !attacking && !landing:
		$Sprite.play("default")
	elif is_on_floor() && !attacking && jumping == 0 && !isDashing && !landing:
		$Sprite.play("walking")
	return Vector2(movement_direction, jumping)
	
func calculate_move_velocity(linear_velocity: Vector2, direction: Vector2, speed: Vector2, is_jump_interrupted: bool, wallJump: bool) -> Vector2:
	if Input.is_action_pressed("dash") and !isShieldUp:
		if is_on_floor():
			if $Sprite.animation != "dash_start" && !attacking:
				$Sprite.play("dash_start")
				create_dust()
		speed.x = 600
		isDashing = 1
		if $Ghost_timer.is_stopped():
			$Ghost_timer.start(.1)
	elif !Input.is_action_pressed("dash") && is_on_floor():
		isDashing = 0
		speed.x = 300
	if is_on_floor():
		speed.y = 0
	
	
	var new_velocity: = linear_velocity
	new_velocity.x = speed.x * direction.x
	new_velocity.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0:
		new_velocity.y = jumpForce * direction.y
		if wallJump:
			new_velocity.x = speed.x * -direction.x
	if is_jump_interrupted and !wallJump:
		new_velocity.y = 50.0
	return new_velocity
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):

func shoot():
	var bullet_instance = Bullet.instantiate()
	get_tree().get_root().add_child(bullet_instance)
	var dir = direction
	dir.y = 0
	if !lookLeft:
		bullet_instance.global_position = gun.global_position
		dir.x = 1
	elif lookLeft:
		dir.x = -1
		bullet_instance.global_position = gun2.global_position
	bullet_instance.direction = dir
	bullet_instance.set_damage(10)
	
func swing():
	var melee_instance = Melee.instantiate()
	add_child(melee_instance)
	if !lookLeft:
		melee_instance.global_position = gun.global_position
	elif lookLeft:
		melee_instance.global_position = gun2.global_position
	melee_instance.set_damage(10)
	
func shield():
		shieldUpInstance.queue_free()
		var shield_instance = Shield.instantiate()
		var dir = direction
		dir.y = 0
		get_tree().get_root().add_child(shield_instance)
		if !lookLeft:
			shield_instance.global_position = gun.global_position
			dir.x = 1
		elif lookLeft:
			shield_instance.global_position = gun2.global_position
			dir.x = -1
		shield_instance.set_damage(10)
		shield_instance.direction = dir
		shield_instance.connect("shieldDied", Callable(self, "setShield"))
		
		
func setShield():
	shieldActive = 0
	
func shieldUp():
	if !shieldActive:
		shieldUpInstance = ShieldUp.instantiate()
		add_child(shieldUpInstance)
		if !lookLeft:
			shieldUpInstance.global_position = gun.global_position
		elif lookLeft:
			shieldUpInstance.global_position = gun2.global_position
			shieldUpInstance.scale.x = -1
		shieldActive = true
		isShieldUp = true
		isDashing = false
		
func createGhost():
	var newGhost = ghost.instantiate()
	get_tree().get_root().add_child(newGhost)
	newGhost.global_position = global_position
	newGhost.flip_h = $Sprite.flip_h
		
func handle_hit(dabledge):
	if(iFrames == 0):
		Health -= dabledge
		HPBar.value = Health
		iFrames = 1
	if Health <= 0:
		die()
		
func die():
	$Sprite.hide()
	$HealthBar.hide()
	global_position = spawn_position
	dead = true
	$RespawnText.show()
	$RespawnTimer.show()
	$CollisionShape2D.disabled = true
	
func respawn():
	Health = MAX_HEALTH
	HPBar.value = Health
	$Sprite.show()
	$HealthBar.show()
	dead = false
	$RespawnText.hide()
	$RespawnTimer.hide()
	$CollisionShape2D.disabled = false
	
	
func update_HUD():
	$Fundamentals/Label.text = str($Build_Menu.fundamentals)
	if currentWeapon == 2:
		$UIStuff/secondary.play("shield")
	else:
		$UIStuff/secondary.play("gun")
	
	
func add_funds(funds):
	$Build_Menu.add_funds(funds)

func set_attacking():
	if attacking:
		attacking = false
	else:
		attacking = true


func stop_landing():
	landing = false
	
func create_dust():
	var newDust = dust.instantiate()
	get_tree().get_root().add_child(newDust)
	newDust.global_position = $dust_spawn.global_position
	if lookLeft:
		newDust.global_position.x *= -1
	newDust.emitting = true

func _on_ghost_timer_timeout() -> void:
	if isDashing:
		createGhost()
		
