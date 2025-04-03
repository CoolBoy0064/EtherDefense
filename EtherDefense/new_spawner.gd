extends Node2D

@export var enemy_scenes: Array[PackedScene]  # Drag enemy scenes into this array
@export var enemy_names: Array[String]  # Corresponding names for enemy types
@export var spawn_points: Array[Node2D]  # Assign spawn locations in the Inspector
@export var waves: Array[Dictionary]  # Define waves in the Inspector
@export var spawn_interval: float = 1.0  # Delay between enemy spawns
@export var time_between_waves: float = 5.0  # Time before the next wave starts

var enemy_dict = {}  # Stores enemy names mapped to scenes
var current_wave = 0
var enemies_remaining = 0

func _ready():
	# Convert arrays into a dictionary
	for i in range(min(enemy_names.size(), enemy_scenes.size())):
		enemy_dict[enemy_names[i]] = enemy_scenes[i]

	start_wave()

func start_wave():
	if current_wave >= waves.size():
		print("All waves completed!")
		return
	
	var wave_data = waves[current_wave]
	print("Starting Wave " + str(current_wave + 1))
	
	# Reset enemies count for the new wave
	enemies_remaining = 0  

	for enemy_type in wave_data.keys():
		var count = wave_data[enemy_type]
		for i in range(count):
			spawn_enemy(enemy_type)
			await get_tree().create_timer(spawn_interval).timeout  

	current_wave += 1


func spawn_enemy(enemy_type: String):
	if spawn_points.is_empty():
		print("No spawn points assigned!")
		return
	
	if enemy_dict.has(enemy_type):
		var enemy_scene = enemy_dict[enemy_type]
		var spawn_location = spawn_points[randi() % spawn_points.size()]
		var enemy = enemy_scene.instantiate()
		enemy.position = spawn_location.global_position
		enemy.connect("enemy_died", Callable(self, "on_enemy_died"))  
		get_parent().add_child(enemy)
		enemies_remaining += 1
	else:
		print("Unknown enemy type: " + enemy_type)

func on_enemy_died():
	enemies_remaining -= 1
	if enemies_remaining <= 0:
		print("Wave " + str(current_wave) + " cleared!")
		await get_tree().create_timer(time_between_waves).timeout
		start_wave()
