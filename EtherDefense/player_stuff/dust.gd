extends GPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	await finished
	print("freeing dust")
	queue_free()
