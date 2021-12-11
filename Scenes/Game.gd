extends Node2D

onready var rooms_container = $RoomsContainer

func _ready():
	ConfigGame.game = self
	
	var player = preload("res://Scenes/Characters/Player/Player.tscn").instance()
	player.connect("hit", $HUD/HealthBar, "set_progress")
	ConfigGame.player = player
	ConfigGame.entity_container = $EntityContainer
	
	level_create()
	
	$EntityContainer/Slime.navigation = $Navigation2D
	$HUD/HealthBar.set_progress_max(ConfigGame.player.health_max)

func _init() -> void:
	var screen_size: Vector2 = OS.get_screen_size()
	var window_size: Vector2 = OS.get_window_size()
	
	OS.set_window_position(screen_size * 0.5 - window_size * 0.5)

func level_finished() -> void:
	level_create()

func level_create() -> void:
	for i in rooms_container.get_children():
		i.queue_free()
	var generation = preload("res://Scripts/ProcGen/Generate.gd").new()
	generation.init($Navigation2D, $RoomsContainer)
	generation.generate()
