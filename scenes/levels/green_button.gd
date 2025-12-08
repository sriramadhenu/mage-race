extends Area2D

@export var wall_node_path: NodePath

var wall: Node = null


func _ready():
	wall = get_node_or_null(wall_node_path)
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node):
	if body is Player:
		if wall:
			wall.destroy()
		set_deferred("monitoring", false)
