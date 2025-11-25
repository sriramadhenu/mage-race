extends Control

@export var full_texture: Texture2D
@export var empty_texture: Texture2D

var is_full: bool = true

func set_full(full: bool) -> void:
	if full == is_full:
		return

	is_full = full

	if full:
		$Icon.texture = full_texture
		$AnimationPlayer.play("pop_in")
	else:
		shake()
		$AnimationPlayer.play("pop")
		await $AnimationPlayer.animation_finished
		$Icon.texture = empty_texture


# shakes a heart a bit each time player loses health
func shake():
	var original_pos = position
	var offset = Vector2(randf() * 3 - 1.5, -3)

	var t = create_tween()
	t.tween_property(self, "position", original_pos + offset, 0.06)
	t.tween_property(self, "position", original_pos, 0.08)


func start_low_health_pulse():
	$AnimationPlayer.play("low_health_pulse")


func stop_low_health_pulse():
	if $AnimationPlayer.current_animation == "low_health_pulse":
		$AnimationPlayer.stop()
	$Icon.scale = Vector2.ONE
