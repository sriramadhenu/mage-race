extends Control

func _ready():
	await get_tree().process_frame
	Hud.hide() # quick fix to hide hud in main menu for now
	for child in Hud.get_children():
		child.hide()

	if has_node("StartButton"):
		$StartButton.pressed.connect(_on_start_pressed)


func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/level_loader.tscn")
	queue_free()
