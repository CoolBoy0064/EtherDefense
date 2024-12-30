extends Node2D


func handle_projectile_spawned(boolet, pos, direct, damage):
	add_child(boolet)
	boolet.global_rotation = direct.angle() + PI / 2.0
	boolet.set_damage(damage)
	boolet.global_position = pos
	boolet.set_direction(direct)
