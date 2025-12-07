extends Character

@export var target: Character
@export var attack_range := 500

var _anim_locked := false
var _is_attacking := false

var _arrow_scene: PackedScene = preload("res://scenes/projectiles/arrow.tscn")

func _physics_process(delta: float):
	if dead:
		return

	# start attacking if the target is within range
	if not _is_attacking:
		var target_in_range = (
			target != null and
			not target.dead and
			target.global_position.distance_to(global_position) < attack_range
		)
		if target_in_range:
			_start_attack_target()

	# play the idle anim when not doing anything
	if not _anim_locked:
		sprite.play("idle")

	super(delta)

func _start_attack_target():
	# face target
	var new_facing := Facing.LEFT if target.global_position.x < global_position.x else Facing.RIGHT
	if new_facing != facing:
		change_facing(new_facing)

	# start attack anim, arrow will be created at end of anim
	_anim_locked = true
	_is_attacking = true
	sprite.play("attack")

func _finish_attack_target():
	var arrow: ArrowProjectile = _arrow_scene.instantiate()
	arrow.global_position = $ArrowSpawn.global_position
	get_tree().current_scene.add_child(arrow)
	
	arrow.add_collision_exception_with(self)
	arrow.launch_at(target.global_position)

func command_callback(_cmd_name: String):
	pass # TODO

func change_facing(new_facing: Facing) -> void:
	super(new_facing)
	var facing_dir = 1 if facing == Facing.RIGHT else Facing.LEFT
	$ArrowSpawn.position.x = abs($ArrowSpawn.position.x) * facing_dir

func _on_animation_finished() -> void:
	_anim_locked = false
	_is_attacking = false

func _on_animation_frame_changed() -> void:
	const ATTACK_SPAWN_ARROW_FRAME := 6
	if _is_attacking and sprite.frame == ATTACK_SPAWN_ARROW_FRAME:
		_finish_attack_target()

func _on_hurt() -> void:
	_anim_locked = true
	sprite.play("hurt")

func _on_death() -> void:
	_anim_locked = true
	sprite.play("death")
