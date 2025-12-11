extends Node2D

@onready var player: Player = $Player

func _ready():
	await get_tree().process_frame
	
	#Always reset health from GameManager when level loads
	player.health = GameManager.player_health
	
	# show HUD
	Hud.show()
	var player_health_node = Hud.get_node_or_null("PlayerHealth")
	if player_health_node:
		player_health_node.show()
	
	# connect and set health
	Hud.connect_player(player)
	Hud.set_health(player.health)
