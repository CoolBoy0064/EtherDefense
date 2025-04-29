extends Node2D

@export var enemy_scenes: Array[PackedScene] 
@export var enemy_names: Array[String]  
@export var spawn_points: Array[Node2D]
@export var waves: Array[Dictionary]
@export var spawn_interval: float = 1.0 

var enemy_dict = {}
var current_wave = 0
var enemies_remaining = 0
var complete = false
var boss_spawned = false

@onready var start_wave_button: Label = get_node("../Player/StartNextWave")
@onready var level_complete_label: Label = get_node("../Player/LevelCompleteLabel")

func _ready():
	for i in range(min(enemy_names.size(), enemy_scenes.size())):
		enemy_dict[enemy_names[i]] = enemy_scenes[i]
		
	level_complete_label.visible = false
	start_wave_button.visible = true
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("start_wave"):
		start_wave_button.visible = false
		start_wave()


func start_wave():
	if current_wave >= waves.size():
		print("All waves completed!")
		level_complete_label.visible = true
		level_complete_label.text = "Level Completed!"
		complete = true
		return
		
	var wave_data = waves[current_wave]
	print("Starting Wave " + str(current_wave + 1))
	enemies_remaining = 0  

	for enemy_type in wave_data.keys(): 
		enemies_remaining += wave_data[enemy_type] #add up all enemies in a wave 
	
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
		if spawn_location.has_method("get_direction"):
			if spawn_location.get_direction():
				if enemy.has_method("change_direction"):
					enemy.change_direction()

		if enemy.has_signal("died"):
			var result = enemy.connect("died", Callable(self, "on_enemy_died"))
			print("Signal connected:", result, "for", enemy_type)

		get_parent().call_deferred("add_child", enemy)
		print("Spawned:", enemy_type, "| enemies_remaining = ", enemies_remaining)
	else:
		print("Unknown enemy type:", enemy_type)

func on_enemy_died():
	print("Enemy died!")
	enemies_remaining -= 1
	if enemies_remaining <= 0:
		print("Wave " + str(current_wave) + " cleared!")
		if current_wave < waves.size() && !complete:
			start_wave_button.visible = true
		else:
			level_complete_label.visible = true
			level_complete_label.text = "Level Completed!"
