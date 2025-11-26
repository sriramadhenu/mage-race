extends CanvasLayer
class_name HUD

@onready var pause_menu: Control = $PauseMenu
@onready var player_health: Control = $PlayerHealth/PlayerHealth

func set_health(value: int):
	player_health.set_health(value)

func connect_player(player):
	player.connect("health_changed", Callable(self, "set_health"))
	#player.connect("died", _on_player_died)


# Pause Menu API
func pause_game():
	pause_menu.pause_game()

func resume_game():
	pause_menu.resume_game()

func toggle_pause():
	if pause_menu.visible:
		pause_menu.resume_game()
	else:
		pause_menu.pause_game()
