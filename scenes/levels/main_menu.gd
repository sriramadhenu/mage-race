extends Control

func _ready():
	await get_tree().process_frame

	Hud.hide()
	for child in Hud.get_children():
		child.hide()

	var start_button = $ButtonsContainer/StartButton
	var quit_button = $ButtonsContainer/QuitButton

	start_button.pressed.connect(_on_start_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_start_pressed():
	GameManager.load_specific_level(0)
	queue_free()

func _on_quit_pressed():
	get_tree().quit()
