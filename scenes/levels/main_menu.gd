extends Control

func _ready():
	if has_node("StartButton"):
		$StartButton.pressed.connect(_on_start_pressed)

func _on_start_pressed():
	# Load first level when button is pressed
	GameManager.load_specific_level(0)
	queue_free()
