extends Control

func _ready():
	visible = false
	
	#allows pause menu to run even when the game is paused
	process_mode = Node.PROCESS_MODE_ALWAYS 


func pause_game() -> void:
	get_tree().paused = true
	visible = true


func resume_game() -> void:
	get_tree().paused = false
	visible = false

# TODO map escape button to project input mappings
func _input(event) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			if visible:
				resume_game()
			else:
				pause_game()


# Eventually, map the actual keys
#func _input(event):
	#if event.is_action_pressed("ui_cancel"):
		#if visible:
			#resume_game()
		#else:
			#pause_game()


func _on_resume_button_pressed() -> void:
	resume_game()


func _on_levels_button_pressed() -> void:
	get_tree().paused = false
	visible = false   # <-- this ensures it disappears

	if LevelManager.current_level_scene:
		LevelManager.current_level_scene.queue_free()
		LevelManager.current_level_scene = null

	get_tree().change_scene_to_file("res://scenes/ui/level_loader.tscn")


func _go_to_loader():
	get_tree().change_scene_to_file("res://scenes/ui/level_loader.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
