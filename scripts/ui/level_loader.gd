extends Control

func _ready():
	Hud.hide()
	for child in Hud.get_children():
		child.hide()

	if has_node("LoadForestLevel"):
		$LoadForestLevel.pressed.connect(_on_load_forest_level_pressed)
	if has_node("LoadIceLevel"):
		$LoadIceLevel.pressed.connect(_on_load_ice_level_pressed)
	if has_node("LoadLavaLevel"):
		$LoadLavaLevel.pressed.connect(_on_load_lava_level_pressed)

func _on_load_forest_level_pressed() -> void:
	_start_level(0)

func _on_load_ice_level_pressed() -> void:
	_start_level(1)

func _on_load_lava_level_pressed() -> void:
	_start_level(2)

func _start_level(index: int) -> void:
	GameManager.load_specific_level(index)
	queue_free()
