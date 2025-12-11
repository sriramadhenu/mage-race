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
	
	if !GameManager.story_seen[0]:
		var speed := player.movement_speed
		player._anim_locked = true
		player.movement_speed = 0
		$TextBox.visible = true
		await get_tree().create_timer(6).timeout
		player._anim_locked = false
		player.movement_speed = speed
		$TextBox.visible = false
		GameManager.story_seen[0] = true
