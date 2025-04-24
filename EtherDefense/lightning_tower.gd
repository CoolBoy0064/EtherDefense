extends CharacterBody2D

#This is the code file for the lightning tower
#The lightning tower takes aim at 5 enemies in a circle and zaps all of them at
#once
#IF it sees more than 5 enemies, it will remove the grounded ones first

@export var damage = 50
@export var MAX_HEALTH = 50
@export var lightning : PackedScene
var health = MAX_HEALTH

var targets = []
var possible_targets = []

func _ready() -> void:
	apply_floor_snap()

func _on_timer_timeout() -> void:
	for target in targets:
		if not target:
			continue
		if target.has_method("handle_hit"):
			print("target damaged")
			var new_lightning = lightning.instantiate()
			get_tree().get_root().add_child(new_lightning)
			new_lightning.global_position = $Damage_Zone/CollisionShape2D.global_position
			new_lightning.set_target(target)
			target.handle_hit(damage)
		else:
			targets.erase(target)
	$Timer.start(1)


func _on_damage_zone_body_entered(body: Node2D) -> void:
	print("body entered")
	if(body.has_method("handle_hit")):
		targets.append(body)
		possible_targets.append(body)
		$Timer.start(1)
	if(len(targets) > 5):
		print("targets exceeded 5")
		var candidate = targets[0]
		for target in targets:
			if candidate.global_position.y < target.global_position.y:
				candidate = target
		targets.erase(candidate)


func _on_damage_zone_body_exited(body: Node2D) -> void:
	print("body exited")
	targets.erase(body)
	possible_targets.erase(body)
	if len(targets) < 5 && len(possible_targets) >= 1:
		print("adding target from possible_targets")
		for target in possible_targets:
			if(!target in targets && !not target): #if the target is not already in targets AND target exists
				targets.append(target)
				break
		
		
func handle_hit(damage):
	health -= damage
	$HealthBar.value = (health/float(MAX_HEALTH)) * 100
	if (health <= 0):
		die()
	
func die():
	queue_free()
