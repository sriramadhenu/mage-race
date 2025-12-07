extends Character

const ATTACK_DAMAGE := 1

@export var target: Character
@export var attack_range := 500
@export var charging_speed_scale := 2.5

@onready var _floor_ray := $FloorRaycast
@onready var _attack_zone := $AttackZone

enum AIState {
	PACING,
	CHARGING,
	ATTACKING,
	RECOVERING,
	HURT,
	DEAD,
}

var _state := AIState.PACING

func _physics_process(delta: float):
	if dead:
		return

	if _state == AIState.PACING:
		_tick_pacing()
	elif _state == AIState.CHARGING:
		_tick_charging()

	super(delta)

func _tick_pacing():
	# if colliding with wall or about to fall off edge
	if is_on_wall() or not _floor_ray.is_colliding():
		_toggle_facing()
	
	velocity.x = movement_speed * _facing_dir()
	sprite.play("walk")

	# if target is in range, start charging them
	if _in_range_of_target():
		_state = AIState.CHARGING

func _tick_charging():
	# make sure the orc is facing the player
	var target_dir := target.global_position.x - global_position.x
	var needs_facing := Facing.RIGHT if target_dir >= 0 else Facing.LEFT
	if facing != needs_facing and abs(target_dir) > 75:
		change_facing(needs_facing)

	# run towards target (unless at edge)
	if _floor_ray.is_colliding():
		velocity.x = charging_speed_scale * movement_speed * _facing_dir()
		sprite.play("run")
	else:
		velocity.x = 0
		sprite.play("idle")

	# attack target if in attack zone
	if target in _attack_zone.get_overlapping_bodies():
		_attack_target()
	# if out of range, go back to pacing
	elif not _in_range_of_target():
		_state = AIState.PACING

func _in_range_of_target():
	return target and not target.dead and global_position.distance_to(target.global_position) < attack_range

func _attack_target():
	_state = AIState.ATTACKING
	sprite.play("attack")
	velocity.x = 0

func _toggle_facing():
	var new_facing := Facing.LEFT if facing == Facing.RIGHT else Facing.RIGHT
	change_facing(new_facing)

func _facing_dir():
	if facing == Facing.RIGHT:
		return 1
	else:
		return -1

func change_facing(new_facing: Facing) -> void:
	super(new_facing)
	# flip important zones
	_floor_ray.position.x = abs(_floor_ray.position.x) * _facing_dir()
	_attack_zone.position.x = abs(_attack_zone.position.x) * _facing_dir()

func command_callback(_cmd_name: String):
	pass # TODO

func _on_animation_finished() -> void:
	# after attacking or being hurt, recover for a little bit
	if _state == AIState.ATTACKING or _state == AIState.HURT:
		_state = AIState.RECOVERING
		sprite.play("idle")
		$RecoverTimer.start()

func _on_animation_frame_changed() -> void:
	const ATTACK_DAMAGE_FRAME := 3
	if _state == AIState.ATTACKING and sprite.frame == ATTACK_DAMAGE_FRAME:
		if target in _attack_zone.get_overlapping_bodies():
			target.take_damage(ATTACK_DAMAGE, self)

func _on_hurt() -> void:
	_state = AIState.HURT
	sprite.play("hurt")
	velocity.x = 0

func _on_death() -> void:
	_state = AIState.DEAD
	sprite.play("death")

func _on_recover_timer_timeout() -> void:
	# recovery is done, start AI loop again
	_state = AIState.CHARGING if _in_range_of_target() else AIState.PACING
