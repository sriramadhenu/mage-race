class_name ArrowProjectile
extends RigidBody2D

@export var damage := 2
@export var speed := 1000
@export var inaccurate := false

var stuck := false
var _last_rotation := 0.0

func _physics_process(_delta: float):
	if not stuck and linear_velocity.length() > 1.0:
		rotation = linear_velocity.angle()
		_last_rotation = rotation

func launch_at(target_pos: Vector2):
	var to := target_pos - global_position
	var g := float(ProjectSettings.get_setting("physics/2d/default_gravity"))

	if to.length() < 0.01:
		return

	var v := speed
	var dx := to.x
	var dy := to.y

	# solve for time-of-flight that keeps initial speed at `speed` under gravity.
	var a := (g * g) * 0.25
	var b := -(dy * g + v * v)
	var c := dx * dx + dy * dy
	var discriminant := b * b - 4.0 * a * c

	var vel := Vector2.ZERO
	if discriminant >= 0.0 and a != 0.0:
		var sqrt_disc := sqrt(discriminant)
		var t_sq := (-b - sqrt_disc) / (2.0 * a)
		if t_sq <= 0.0:
			t_sq = (-b + sqrt_disc) / (2.0 * a)

		if t_sq > 0.0:
			var t := sqrt(t_sq)
			vel.x = dx / t
			vel.y = dy / t - 0.5 * g * t

	# fallback to straight shot if target is unreachable
	if vel == Vector2.ZERO:
		vel = to.normalized() * v

	if inaccurate:
		const INACCURAGE_DEGREES := 7.5
		var spread := deg_to_rad(INACCURAGE_DEGREES)
		vel = vel.rotated(randf_range(-spread, spread))

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
		body.take_damage(damage, self)

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
