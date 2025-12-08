extends Node


const LEVELS = [
	"res://scenes/levels/level_forest.tscn",
	"res://scenes/levels/level_ice.tscn",
	"res://scenes/levels/level_lava.tscn",
]


var current_level_scene: Node = null
var hud_scene: PackedScene = preload("res://scenes/ui/hud/player_health/player_health.tscn")
var hud_instance: CanvasLayer = null


func _ready():
	GameManager.level_changed.connect(_on_level_changed)


func _on_level_button_pressed(level_index):
	GameManager.load_specific_level(level_index)
	queue_free()  


func _on_level_changed(level_index: int):
	load_level(level_index)


func _ensure_hud():
	if hud_instance == null:
		hud_instance = hud_scene.instantiate()
		get_tree().root.add_child.call_deferred(hud_instance)


func load_level(level_index: int):
	if current_level_scene:
		current_level_scene.queue_free()
		await current_level_scene.tree_exited
	
	if level_index < LEVELS.size() and level_index >= 0:
		var level_path = LEVELS[level_index]
		var level_scene = load(level_path)
		
		if level_scene:
			_ensure_hud()
			hud_instance.visible = true
			current_level_scene = level_scene.instantiate()
			get_tree().root.add_child.call_deferred(current_level_scene)
		else:
			print("Could not load level from: ", level_path)
	else:
		if hud_instance:
			hud_instance.visible = false
		GameManager.change_state(GameManager.GameState.GAME_OVER)


func unload_level():
	if current_level_scene:
		current_level_scene.queue_free()
		current_level_scene = null


func restart_current_level():
	load_level(GameManager.current_level)
