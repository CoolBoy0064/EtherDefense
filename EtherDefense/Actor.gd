extends CharacterBody2D
class_name Actor
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const FLOOR_NORMAL: =Vector2.UP
@export var speed = Vector2(200, 1000)
@export var gravity = 1600
@export var Health = 50
@export var damage = 0
@export var isEnemy = false
@export var isPlayer = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_Damage():
	return damage

func is_enemy():
	return isEnemy
	
func is_player():
	return isPlayer
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
