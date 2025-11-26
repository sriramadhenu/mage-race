extends Control

func _ready():
	await get_tree().process_frame
	Hud.hide() # quick fix to hide hud in main menu for now
	for child in Hud.get_children():
		child.hide()

	if has_node("StartButton"):
		$StartButton.pressed.connect(_on_start_pressed)


func _on_start_pressed():
	# Load first level when button is pressed
	GameManager.load_specific_level(0)
	queue_free()
