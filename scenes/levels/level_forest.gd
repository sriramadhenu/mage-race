extends Node2D
@onready var player: Player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().process_frame
	
	# quick rudimentary way to show HUD again (for now)
	Hud.show()
	Hud.get_node("PlayerHealth").show()
	
	Hud.connect_player(player)
	Hud.set_health(player.health)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
