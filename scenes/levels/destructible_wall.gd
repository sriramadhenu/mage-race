class_name DestructibleWall
extends StaticBody2D

@export var health: int = 1

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	# Make sure we can receive body_entered signals from the IceSpell
	# The IceSpell calls _on_body_entered() when it hits a PhysicsBody2D
	
	# Add a small delay to ensure everything is set up
	await get_tree().process_frame
	
	# We don't need to add an Area2D - the IceSpell will detect this StaticBody2D directly
	# because StaticBody2D is a PhysicsBody2D

func _on_body_entered(_body: Node2D) -> void:
	# This function should be called by the IceSpell when it hits this wall
	# But we need to explicitly check for IceSpell hitting us
	pass  # We'll handle this differently

# Add this method to be called by the IceSpell
func take_damage_from_spell(damage: int) -> void:
	health -= damage
	
	# Visual feedback
	if sprite:
		var tween = get_tree().create_tween()
		tween.tween_property(sprite, "modulate", Color(2.0, 0.5, 0.5), 0.05)
		tween.tween_property(sprite, "modulate", Color.WHITE, 0.05)
	
	if health <= 0:
		_destroy()

func _destroy() -> void:
	
	# Disable collision immediately
	if collision_shape:
		collision_shape.disabled = true
	
	# Fade out and disappear
	if sprite:
		var tween = get_tree().create_tween()
		tween.tween_property(sprite, "modulate:a", 0.0, 0.5)
		tween.tween_callback(queue_free)
