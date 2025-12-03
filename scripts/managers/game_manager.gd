extends Node

# Game States
enum GameState {
	MAIN_MENU,
	PLAYING,
	PAUSED,
	LEVEL_SELECT,
	LEVEL_COMPLETE,
	GAME_OVER
}

var current_state: GameState = GameState.MAIN_MENU
var current_level: int = 0
var player_health: int = 100
var max_health: int = 100
var collected_relics: Array = []
var last_played_level: int = 0

signal state_changed(new_state: GameState)
signal level_changed(level_number: int)
signal player_health_changed(new_health: int)
signal player_died
signal relic_collected(relic_name: String)

func _ready():
	print("Ready")

# State Management
func change_state(new_state: GameState):
	state_changed.emit(new_state)

# Level Management
func load_next_level():
	current_level += 1
	last_played_level = current_level
	level_changed.emit(current_level)
	change_state(GameState.PLAYING)

func load_specific_level(level_index: int):
	current_level = level_index
	last_played_level = level_index
	player_health = max_health
	level_changed.emit(level_index)
	change_state(GameState.PLAYING)

func restart_current_level():
	player_health = max_health
	level_changed.emit(current_level)
	change_state(GameState.PLAYING)

# Player Health Management
func damage_player(amount: int):
	player_health = max(0, player_health - amount)
	player_health_changed.emit(player_health)
	
	if player_health <= 0:
		player_died.emit()
		change_state(GameState.LEVEL_SELECT)

func heal_player(amount: int):
	player_health = min(max_health, player_health + amount)
	player_health_changed.emit(player_health)

# Puzzle Collection
func collect_relic(relic_name: String):
	if not collected_relics.has(relic_name):
		collected_relics.append(relic_name)
		relic_collected.emit(relic_name)

# Utility Functions
func reset_game():
	current_level = 0
	player_health = max_health
	collected_relics.clear()
	change_state(GameState.MAIN_MENU)

func get_last_played_level() -> int:
	return last_played_level
