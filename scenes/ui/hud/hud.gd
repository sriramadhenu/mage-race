extends CanvasLayer
class_name HUDController

@onready var root_ui := get_child(0)
@onready var pause_menu: Control = $PauseMenu

func _ready():
	_update_visibility()
	get_tree().scene_changed.connect(_update_visibility)
	GameManager.state_changed.connect(_on_state_changed)

func _on_state_changed(_new_state: GameManager.GameState):
	_update_visibility()

func _update_visibility():
	var scene := get_tree().current_scene
	if scene == null:
		root_ui.visible = false
		return
	
	var path := scene.scene_file_path
	var hud_visible := path.begins_with("res://scenes/levels/")
	root_ui.visible = hud_visible
	
	# hide ONLY PlayerHealth during level select, not root_ui
	if GameManager.current_state == GameManager.GameState.LEVEL_SELECT:
		var player_health = root_ui.get_node_or_null("PlayerHealth")
		if player_health:
			player_health.visible = false
		return

func _get_player_health():
	if root_ui.has_node("PlayerHealth"):
		return root_ui.get_node("PlayerHealth")
	return null

func set_health(value: int):
	var ph = _get_player_health()
	if ph:
		ph.set_health(value)

func connect_player(player):
	if player.health_changed.is_connected(Callable(self, "set_health")):
		return
	player.connect("health_changed", Callable(self, "set_health"))

# pause menu utilitiesi
func pause_game():
	pause_menu.pause_game()

func resume_game():
	pause_menu.resume_game()

func toggle_pause():
	if pause_menu.visible:
		pause_menu.resume_game()
	else:
		pause_menu.pause_game()
