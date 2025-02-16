extends CharacterBody2D
class_name Gem

@export var max_health: int = 100
@export var health: int = 100
var iFrames: bool = false
@onready var HPBar = $HealthBar
@onready var iFrameTimer = $IFrameTimer  

func _ready():
	HPBar.max_value = 100  
	HPBar.value = (health / float(max_health)) * 100  

func handle_hit(damage: int):
	if not iFrames:
		health -= damage
		health = max(health, 0)  
		HPBar.value = (health / float(max_health)) * 100  

		iFrames = true
		iFrameTimer.start()  

		if health <= 0:
			die()

func _on_EnemyDetector_body_entered(body):
	if body.has_method("get_Damage"):
		handle_hit(body.get_Damage())

func die():
	queue_free()  
	get_tree().change_scene_to_file("res://GameOver.tscn")  

func _on_IFrameTimer_timeout():
	iFrames = false
