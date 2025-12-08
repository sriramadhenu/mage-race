extends Control

func _ready():
	await get_tree().process_frame

	# Connect Start button
	if has_node("ButtonsContainer/StartButton"):
		$ButtonsContainer/StartButton.pressed.connect(_on_start_pressed)

	# Connect Quit button
	if has_node("ButtonsContainer/QuitButton"):
		$ButtonsContainer/QuitButton.pressed.connect(_on_quit_pressed)


func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/level_loader.tscn")
	#queue_free()


func _on_quit_pressed():
	get_tree().quit()
