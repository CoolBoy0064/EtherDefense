extends AnimatedSprite2D


@export var right = false #var that tracks whether this spawn is facing left or right (Defaults to facing left)


func get_direction():
	print("is this portal facing right? ", right)
	return right
