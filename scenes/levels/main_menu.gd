extends Control

func _ready():
	await get_tree().process_frame

	# Connect Start button
	if has_node("UIContainer/StartButton"):
		$UIContainer/StartButton.pressed.connect(_on_start_pressed)

	# Connect Quit button
	if has_node("UIContainer/QuitButton"):
		$UIContainer/QuitButton.pressed.connect(_on_quit_pressed)

	# Hide HUD for the menu
	Hud.hide()
	for child in Hud.get_children():
		child.hide()	
	
	# Play menu music
	$Audio/menu_music.play()

	# Stop level music if present
	if LevelMusic:
		LevelMusic.stop()


func _on_start_pressed():
	$Audio/start_button.play()
	$Audio/menu_music.stop()
	await get_tree().create_timer(0.4).timeout
	get_tree().change_scene_to_file("res://scenes/ui/level_loader.tscn")


func _on_quit_pressed():
	get_tree().quit()
