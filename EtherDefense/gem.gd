extends CharacterBody2D
class_name Gem

@export var max_health: int = 100
@export var health: int = 100
var iFrames: bool = false
@onready var HPBar = $HealthBar
@onready var timer = $IFrameTimer  

func _ready():
	HPBar.max_value = 100  
	HPBar.value = (health / float(max_health)) * 100  

func handle_hit(damage: int):
	if not iFrames:
		health -= damage
		health = max(health, 0)  
		HPBar.value = (health / float(max_health)) * 100  

		if health <= 0:
			die()

func _on_EnemyDetector_body_entered(body):
	if body.has_method("get_Damage"):
		handle_hit(body.get_Damage())

func die():
	$Control.show()
	$Camera2D.enabled = true
	$Camera2D.make_current()
	timer.start(.5)
	await timer.timeout
	$Control.game_over()
	

func _on_IFrameTimer_timeout():
	iFrames = false
	
func is_a_gem():
	return true
