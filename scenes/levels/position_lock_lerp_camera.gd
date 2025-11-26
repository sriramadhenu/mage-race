extends Camera2D

@export var target: Node2D
@export var follow_speed: float = 5.0
@export var catchup_speed: float = 8.0
@export var leash_distance: float = 25.0

func _process(delta: float) -> void:
	if !is_current():
		return

	var target_pos = target.global_position
	var camera_pos = position

	var offset = Vector2(target_pos.x - camera_pos.x, 0)
	var distance = offset.length()

	var speed = follow_speed if target.velocity.length() > 0.1 else catchup_speed

	if distance > leash_distance:
		camera_pos.x = target_pos.x - offset.normalized().x * leash_distance
	else:
		camera_pos.x = lerp(camera_pos.x, target_pos.x, delta * speed)

	position = camera_pos
