extends Control



@export var Tower1 : PackedScene
@export var Tower2 : PackedScene
@export var Tower1_cost = 10
@export var Tower2_cost = 10
@export var MAX_FUNDAMENTALS = 50
var fundamentals = 20

#Creates a turret at the placement spot and hides the build menu
func _on_turret_pressed() -> void:
	if fundamentals < Tower1_cost:
		print("ERROR not enough funds")
		hide()
		return
	
	fundamentals = fundamentals - Tower1_cost
	get_parent().update_HUD()
	var tower_instance = Tower1.instantiate()
	get_tree().get_root().add_child(tower_instance)
	tower_instance.global_position = $Placement_spot.global_position
	if get_parent().lookLeft:
		tower_instance.flip_tower() #if the player is looking to the left, spawn the tower facing left
		tower_instance.global_position = $Placement_spot2.global_position
	tower_instance.apply_floor_snap()
	hide()


#Hides the Build Menu and does nothing else
func _on_exit_pressed() -> void:
	hide()



#Creates a wall of light at the placement spot and hides the build menu
func _on_wall_pressed() -> void:
	if fundamentals < Tower2_cost:
		print("ERROR not enough funds")
		hide()
		return
	
	fundamentals = fundamentals - Tower2_cost
	get_parent().update_HUD()
	var tower_instance = Tower2.instantiate()
	get_tree().get_root().add_child(tower_instance)
	tower_instance.global_position = $Placement_spot.global_position
	if get_parent().lookLeft:
		tower_instance.flip_tower() #if the player is looking to the left, spawn the tower facing left
		tower_instance.global_position = $Placement_spot2.global_position
	tower_instance.apply_floor_snap()
	hide()

func add_funds(funds):
	fundamentals = fundamentals + funds
	get_parent().update_HUD()
	print("current funds: ", fundamentals)
