extends Node2D


@onready var projectile_manager = $ProjectileManage
@onready var player = $Player
@onready var Turret = $Turret


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.connect("gunFired", Callable(projectile_manager, "handle_projectile_spawned"))
	Turret.connect("Turret_Shot", Callable(projectile_manager, "handle_projectile_spawned"))
	
