class_name DestructibleWall
extends StaticBody2D

@export var health: int = 100

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func take_damage_from_spell(damage: int) -> void:
	# Check if the node is still valid before proceeding
	if not is_instance_valid(self):
		return
		
	health -= damage
	
	# Visual feedback
	if sprite and is_instance_valid(sprite):
		var tween = get_tree().create_tween()
		tween.tween_property(sprite, "modulate", Color(2.0, 0.5, 0.5), 0.05)
		tween.tween_property(sprite, "modulate", Color.WHITE, 0.05)
	
	if health <= 0:
		_destroy()

func _destroy() -> void:
	# Mark the wall as destroyed immediately
	set_process(false)
	set_physics_process(false)
	
	# Disable collision using set_deferred - this is safer than call_deferred
	if collision_shape and is_instance_valid(collision_shape):
		collision_shape.set_deferred("disabled", true)
	
	# Remove this StaticBody2D from processing
	set_collision_layer(0)
	set_collision_mask(0)
	
	# Fade out and disappear
	if sprite and is_instance_valid(sprite):
		var tween = get_tree().create_tween()
		tween.tween_property(sprite, "modulate:a", 0.0, 0.5)
		tween.tween_callback(_queue_free_safely)

func _queue_free_safely() -> void:
	# Ensure we're still valid before queue_free
	if is_instance_valid(self):
		queue_free()
