extends CharacterBody2D

@export var length = 5
@export var speed = Vector2(400, 400)
@export var lightning : PackedScene
var target_location
var target_angle = Vector2.ZERO
var stop = false
var movespeed = 15
# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		if(target_location - global_position < Vector2(100, 100)):
			stop = true
			$Timer.start(.3)
		if target_angle != Vector2.ZERO && !stop:
			for i in movespeed:
				move_and_slide()
				var new_lightning = lightning.instantiate()
				get_tree().get_root().add_child(new_lightning)
				new_lightning.global_position = global_position
				new_lightning.emitting = true


func set_target(target):
	target_location = target.global_position
	print(target_location)
	target_angle = Vector2.RIGHT.rotated(get_angle_to(target_location))
	velocity = speed * target_angle


func _on_timer_timeout() -> void:
	queue_free()
