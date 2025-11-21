extends Node

func _on_load_forest_level_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level_forest.tscn")


func _on_load_ice_level_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level_ice.tscn")


func _on_load_lava_level_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level_lava.tscn")
