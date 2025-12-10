class_name SkeletonEnemy
extends Character

@export var target: Character
@export var charge_range := 1000
@export var attack_range := 500

enum AIState {
	IDLE,
	CHARGING,
	ATTACK_READY,
	ATTACKING,
	RECOVERING,
	HURT,
	DEAD,
}

var _state := AIState.IDLE

var _arrow_scene: PackedScene = preload("res://scenes/projectiles/arrow.tscn")

func _physics_process(delta: float):
	if dead:
		return

	match _state:
		AIState.IDLE: _tick_idle()
		AIState.CHARGING: _tick_charging()
		AIState.ATTACK_READY: _tick_attack_ready()

	super(delta)

func _tick_idle():
	velocity.x = 0
	sprite.play("idle")

	if _in_attack_range_of_target():
		_state = AIState.ATTACK_READY
	elif _in_charge_range_of_target():
		_state = AIState.CHARGING

func _tick_charging():
	_face_target()
	velocity.x = movement_speed * _facing_dir()
	if is_on_floor() and velocity.x > 1:
		sprite.play("run")
	else:
		sprite.play("idle")

	# if on wall, try jumping over wall
	if is_on_floor() and is_on_wall():
		velocity.y += jump_velocity

	if _in_attack_range_of_target():
		_state = AIState.ATTACK_READY
	elif not _in_charge_range_of_target():
		_state = AIState.IDLE

func _tick_attack_ready():
	velocity.x = 0
	if not _in_attack_range_of_target():
		_state = AIState.CHARGING if _in_charge_range_of_target() else AIState.IDLE
	else:
		_start_attack_target()

func _in_charge_range_of_target():
	return target and not target.dead and global_position.distance_to(target.global_position) < charge_range
func _in_attack_range_of_target():
	return target and not target.dead and global_position.distance_to(target.global_position) < attack_range

func _start_attack_target():
	_face_target()

	# start attack anim, arrow will be created near end of anim
	_state = AIState.ATTACKING
	sprite.play("attack")

func _finish_attack_target():
	var arrow: ArrowProjectile = _arrow_scene.instantiate()
	arrow.inaccurate = true
	arrow.global_position = $ArrowSpawn.global_position
	
	var parent := get_parent()
	parent.add_child(arrow)

	arrow.add_collision_exception_with(self)
	arrow.launch_at(target.global_position)

func command_callback(_cmd_name: String):
	pass # TODO

func _face_target():
	# face target
	var new_facing := Facing.LEFT if target.global_position.x < global_position.x else Facing.RIGHT
	if new_facing != facing:
		change_facing(new_facing)

func _facing_dir():
	return 1 if facing == Facing.RIGHT else -1

func change_facing(new_facing: Facing) -> void:
	super(new_facing)
	var facing_dir = 1 if facing == Facing.RIGHT else Facing.LEFT
	$ArrowSpawn.position.x = abs($ArrowSpawn.position.x) * facing_dir

func _on_animation_finished() -> void:
	match _state:
		AIState.ATTACKING: _state = AIState.ATTACK_READY
		AIState.HURT:
			_state = AIState.RECOVERING
			$RecoverTimer.start()

func _on_animation_frame_changed() -> void:
	const ATTACK_SPAWN_ARROW_FRAME := 6
	if _state == AIState.ATTACKING and sprite.frame == ATTACK_SPAWN_ARROW_FRAME:
		_finish_attack_target()

func _on_hurt() -> void:
	velocity.x = 0
	_state = AIState.HURT
	sprite.play("hurt")

func _on_death() -> void:
	_state = AIState.DEAD
	sprite.play("death")

func _on_recover_timer_timeout() -> void:
	if _in_attack_range_of_target():
		_state = AIState.ATTACK_READY
	elif _in_charge_range_of_target():
		_state = AIState.CHARGING
	else:
		_state = AIState.IDLE
