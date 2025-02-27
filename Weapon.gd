extends Area2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text

@onready var anim = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func attack():
	anim.play("Swing")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Weapon_body_entered(body: Node) -> void:
	if body.has_method("handle_hit"):
		body.handle_hit(10)
