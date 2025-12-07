extends Control

@onready var forest_button = $LoadForestLevel
@onready var ice_button = $LoadIceLevel
@onready var lava_button = $LoadLavaLevel

func _ready():
	_safe_connect(forest_button, _on_load_forest_level_pressed)
	_safe_connect(ice_button, _on_load_ice_level_pressed)
	_safe_connect(lava_button, _on_load_lava_level_pressed)
	
func _on_load_forest_level_pressed() -> void:
	_start_level(0)

func _on_load_ice_level_pressed() -> void:
	_start_level(1)

func _on_load_lava_level_pressed() -> void:
	_start_level(2)

func _safe_connect(button: Button, callback: Callable):
	if not button.pressed.is_connected(callback):
		button.pressed.connect(callback)
		
func _start_level(index: int) -> void:
	GameManager.load_specific_level(index)
	queue_free()
