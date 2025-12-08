extends Area2D

@export var damage: int = 2

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Player and not body._is_dying:
		var player := body as Player
		player.take_damage(damage, self)

		if GameManager.player_health > 0:
			player._on_hurt()
		else:
			player._on_death()
