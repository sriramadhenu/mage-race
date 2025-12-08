extends Area2D


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node) -> void:
	if body is Player:
		GameManager.change_state(GameManager.GameState.LEVEL_SELECT)
		get_tree().call_deferred("change_scene_to_file", "res://scenes/ui/level_loader.tscn")
