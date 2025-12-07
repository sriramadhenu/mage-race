class_name ArrowProjectile
extends RigidBody2D

@export var damage := 2
@export var speed := 1000

var stuck := false
var _last_rotation := 0.0

func _physics_process(_delta: float):
	if not stuck and linear_velocity.length() > 1.0:
		rotation = linear_velocity.angle()
		_last_rotation = rotation

func launch_at(target_pos: Vector2):
	var to := target_pos - global_position
	var vel := to.normalized() * speed

	var up_boost: float = clamp(to.length() * 0.02, 0.0, speed)
	vel.y -= up_boost
	
	linear_velocity = vel
	rotation = vel.angle()

func _on_body_entered(body: Node) -> void:
	stuck = true
	# stop physics
	set_deferred("freeze", true)
	# fix rotation
	rotation = _last_rotation

	# apply damage if it's a character
	if body is Character:
		body.take_damage(damage)

	# stick to the hit body (so it moves with them)
	if body is Node2D:
		var t := global_transform
		get_parent().remove_child(self)
		body.add_child(self)
		body.move_child(self, 0)
		global_transform = t

	_start_fade_out()

func _start_fade_out():
	# wait to fade out
	$StartFadeOutTimer.start()
	await $StartFadeOutTimer.timeout

	# fade out
	var tween := create_tween()
	tween.tween_property($Sprite2D, "modulate:a", 0.0, 0.4)
	await tween.finished

	# remove this arrow
	queue_free()
