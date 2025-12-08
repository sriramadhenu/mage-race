extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D):
	if body is Player and not body._is_dying:
		
		GameManager.player_health = 0
		GameManager.player_health_changed.emit(0)
		
		body.health = 0
		body.dead = true
		
		GameManager.player_died.emit()
		body._on_death()
