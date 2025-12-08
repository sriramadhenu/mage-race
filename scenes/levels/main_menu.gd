extends Control

func _ready():
	await get_tree().process_frame

	# Connect Start button
	if has_node("ButtonsContainer/StartButton"):
		$ButtonsContainer/StartButton.pressed.connect(_on_start_pressed)

	# Connect Quit button
	if has_node("ButtonsContainer/QuitButton"):
		$ButtonsContainer/QuitButton.pressed.connect(_on_quit_pressed)

	Hud.hide() # quick fix to hide hud in main menu for now
	for child in Hud.get_children():
		child.hide()	
	
	$Audio/menu_music.play()
	if LevelMusic:
		LevelMusic.stop()
	
func _on_start_pressed():
	$Audio/start_button.play()
	$Audio/menu_music.stop()
	await get_tree().create_timer(0.4).timeout
	get_tree().change_scene_to_file("res://scenes/ui/level_loader.tscn")
	queue_free()


func _on_quit_pressed():
	get_tree().quit()
	call_deferred("queue_free")
