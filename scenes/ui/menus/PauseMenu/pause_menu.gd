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


func _on_quit_button_pressed() -> void:
	get_tree().quit()
