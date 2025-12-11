extends Control

func _ready():
	$BackgroundMusic.play()
	# Connect the Back button 
	if has_node("BackButton"):
		$BackButton.pressed.connect(_on_back_pressed)

func _on_back_pressed():
	# Go back to main menu
	get_tree().change_scene_to_file("res://scenes/ui/menus/main_menu.tscn")
