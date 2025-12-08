extends CanvasLayer
class_name HUDController

@onready var root_ui := get_child(0)
@onready var pause_menu: Control = $Root/PauseMenu

func _ready():
	_update_visibility()
	get_tree().scene_changed.connect(_update_visibility)


func _update_visibility():
	var scene := get_tree().current_scene
	if scene == null:
		root_ui.visible = false
		return

	var path := scene.scene_file_path
	var show := path.begins_with("res://scenes/levels/")
	root_ui.visible = show

	print("HUD (root) visible:", show, " Scene:", path)


func _get_player_health():
	if root_ui.has_node("PlayerHealth/PlayerHealth"):
		return root_ui.get_node("PlayerHealth/PlayerHealth")
	return null


func set_health(value: int):
	var ph = _get_player_health()
	if ph:
		ph.set_health(value)
	else:
		print("⚠ HUD tried to update health before UI was ready")


func connect_player(player):
	player.connect("health_changed", Callable(self, "set_health"))


# Pause menu
func pause_game():
	pause_menu.pause_game()


func resume_game():
	pause_menu.resume_game()


func toggle_pause():
	if pause_menu.visible:
		pause_menu.resume_game()
	else:
		pause_menu.pause_game()
