extends Control

func _ready():
	await get_tree().process_frame

	# Connect Start button
	if has_node("UIContainer/StartButton"):
		$UIContainer/StartButton.pressed.connect(_on_start_pressed)


	if has_node("ButtonsContainer/QuitButton"):
		$ButtonsContainer/QuitButton.pressed.connect(_on_quit_pressed)
		
		# Connect How to play button
	if has_node("ButtonsContainer/HowToPlayButton"):
		$ButtonsContainer/HowToPlayButton.pressed.connect(_on_how_to_play_pressed)

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


func _on_how_to_play_pressed():
	$Audio/start_button.play()
	await get_tree().create_timer(0.4).timeout
	get_tree().change_scene_to_file("res://scenes/ui/how_to_play.tscn")
	#queue_free()
