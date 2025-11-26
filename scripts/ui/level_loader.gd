extends Node

func _on_load_forest_level_pressed() -> void:
	GameManager.load_specific_level(0)


func _on_load_ice_level_pressed() -> void:
	GameManager.load_specific_level(1)


func _on_load_lava_level_pressed() -> void:
	GameManager.load_specific_level(2)
