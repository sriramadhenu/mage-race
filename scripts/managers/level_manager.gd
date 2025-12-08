extends Node

const LEVELS = [
	"res://scenes/levels/level_forest.tscn",
	"res://scenes/levels/level_ice.tscn",
	"res://scenes/levels/level_lava.tscn",
]

var current_level_scene: Node = null
var hud_scene: PackedScene = preload("res://scenes/ui/hud/player_health/player_health.tscn")


func _ready():
	GameManager.level_changed.connect(_on_level_changed)


func _on_level_changed(level_index: int):
	load_level(level_index)


func _ensure_hud():
	if Engine.has_singleton("Hud"):
		if Hud.visible == false:
			Hud.show()
		return

	var new_hud = hud_scene.instantiate()
	get_tree().root.add_child.call_deferred(new_hud)


# Level management
func load_level(level_index: int):
	# remove current level if it exists
	if current_level_scene:
		current_level_scene.queue_free()
		await current_level_scene.tree_exited

	# Load new level
	if level_index >= 0 and level_index < LEVELS.size():
		var level_res = load(LEVELS[level_index])
		if level_res:
			_ensure_hud()       
			Hud.visible = true    
			current_level_scene = level_res.instantiate()
			get_tree().root.add_child.call_deferred(current_level_scene)
		else:
			print("Could not load level at: ", LEVELS[level_index])
	else:
		Hud.visible = false
		GameManager.change_state(GameManager.GameState.GAME_OVER)


func restart_current_level():
	load_level(GameManager.current_level)
