extends Node

const LEVELS = [
	"res://scenes/levels/level_forest.tscn",
	"res://scenes/levels/level_ice.tscn",
	"res://scenes/levels/level_lava.tscn",
]

var current_level_scene: Node = null

func _ready():
	GameManager.level_changed.connect(_on_level_changed)

func _on_level_changed(level_index: int):
	load_level(level_index)

func load_level(level_index: int):
	# remove current level if it exists
	if current_level_scene:
		current_level_scene.queue_free()
		await current_level_scene.tree_exited
	
	# load new level
	if level_index >= 0 and level_index < LEVELS.size():
		var level_res = load(LEVELS[level_index])
		if level_res:
			current_level_scene = level_res.instantiate()
			get_tree().root.add_child.call_deferred(current_level_scene)
		else:
			print("Could not load level at: ", LEVELS[level_index])
	else:
		GameManager.change_state(GameManager.GameState.GAME_OVER)

func restart_current_level():
	load_level(GameManager.current_level)
