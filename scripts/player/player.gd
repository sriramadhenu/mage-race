class_name Player
extends Character 

@onready var _prevent_dash_zone: Area2D = $PreventDashZone

# player states
var cmd_list: Array[Command]
var _anim_locked := false
var _is_casting := false
var _is_dying := false
var _knockback_velocity := Vector2.ZERO
var _ice_spell_scene: PackedScene = preload("res://scenes/projectiles/ice_spell.tscn")

signal health_changed(new_hp)

func _ready() -> void:
	health = 5
	max_health = 5
	bind_player_input_commands()
	command_callback("respawn")
	if not death.is_connected(_on_death):
		death.connect(_on_death)


func _physics_process(delta: float) -> void:
	if dead or _is_dying:
		velocity = Vector2.ZERO
		super(delta)
		return

	# Update dash every frame (important)
	dash_cmd.update(self, delta)
	if dash_cmd.is_dashing:
		_spawn_dash_ghost()
		_apply_knockback(delta)
		super(delta)
		return
		
	# If any queued commands exist, process them first
	if len(cmd_list) > 0:
		var command_status: Command.Status = cmd_list.front().execute(self)
		if Command.Status.DONE == command_status:
			cmd_list.pop_front()
		return
	
	if Input.is_action_just_pressed("jump"):
		up_cmd.execute(self)
	elif Input.is_action_just_released("jump"):
		velocity.y = maxf(velocity.y, 0) # cancel jump if released early

	if not _is_casting and Input.is_action_just_pressed("dash"):
		var dash_obstructed := _prevent_dash_zone.get_overlapping_bodies().any(
			func(body: Node2D): return body is Character and not body.dead
		)
		if not dash_obstructed:
			dash_cmd.execute(self)
	if Input.is_action_just_pressed("attack_ice"):
		_attack_ice()
	if Input.is_action_just_pressed("attack_ice_left"):
		_shoot_left()
	if Input.is_action_just_pressed("attack_ice_right"):
		_shoot_right()

	var move_input := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	if _is_casting and is_on_floor():
		move_input = 0.0

	if move_input > 0.1:
		right_cmd.execute(self)
	elif move_input < -0.1:
		left_cmd.execute(self)
	else:
		idle.execute(self)

	var moving = abs(move_input) > 0.1
	if not _anim_locked:
		if moving and is_on_floor():
			sprite.play("walk")
		else:
			sprite.play("idle")

	_apply_knockback(delta)
	super(delta)



func _spawn_dash_ghost():
	var ghost = AnimatedSprite2D.new()
	ghost.sprite_frames = $AnimatedSprite2D.sprite_frames
	ghost.animation = $AnimatedSprite2D.animation
	ghost.frame = $AnimatedSprite2D.frame
	ghost.flip_h = $AnimatedSprite2D.flip_h
	ghost.global_position = global_position
	ghost.modulate = Color(1.0, 1.0, 1.0, 0.7)
	ghost.scale = $AnimatedSprite2D.scale

	get_parent().add_child(ghost)

	var tween = get_tree().create_tween()
	tween.tween_property(ghost, "modulate:a", 0.0, 0.18)
	tween.tween_callback(ghost.queue_free)
	
	
func _attack_ice():
	if _anim_locked:
		return
	_anim_locked = true
	_is_casting = true
	sprite.play("cast_forward")

	var facing_dir := 1 if facing == Facing.RIGHT else -1
	var ice_spell: IceSpell = _ice_spell_scene.instantiate()
	ice_spell.ignore = self
	ice_spell.velocity.x *= facing_dir
	ice_spell.position = Vector2(50 * facing_dir, -30)

	# add the spell as a child of this node so it follows the player as its forming
	# when the spell is fully formed, it will reparent
	add_child(ice_spell)


func change_facing(new_facing: Facing):
	if _is_casting:
		return
	super(new_facing)
	var facing_dir := 1 if facing == Facing.RIGHT else -1
	$CollisionShape2D.position.x = abs($CollisionShape2D.position.x) * facing_dir
	$PreventDashZone/CollisionShape2D.position.x = abs($PreventDashZone/CollisionShape2D.position.x) * facing_dir


func bind_player_input_commands():
	right_cmd = MoveRightCommand.new()
	left_cmd = MoveLeftCommand.new()
	up_cmd = JumpCommand.new()
	idle = IdleCommand.new()
	dash_cmd = DashCommand.new()


func unbind_player_input_commands():
	right_cmd = IdleCommand.new()
	left_cmd = IdleCommand.new()
	up_cmd = IdleCommand.new()
	idle = IdleCommand.new()
	dash_cmd = IdleCommand.new()


func command_callback(cmd_name: String) -> void:
	var player: AudioStreamPlayer2D = null
	match cmd_name:
		"jump": player = $Audio/jump
		"dash": player = $Audio/dash
		"walk": player = $Audio/walk
		"respawn": player = $Audio/respawn
		"death": player = $Audio/death
	if player != null and not player.playing:
		player.play()


func _on_animation_finished() -> void:
	_anim_locked = false
	_is_casting = false


func _on_hurt() -> void:
	_anim_locked = true
	sprite.play("hurt")


func _on_death() -> void:
	_anim_locked = true
	_is_dying = true
	sprite.play("death")
	command_callback("death")
	velocity = Vector2.ZERO
	cmd_list.clear()
	
	if dash_cmd and dash_cmd.is_dashing:
		dash_cmd.is_dashing = false
	
	var death_timer := Timer.new()
	death_timer.wait_time = 2.5
	death_timer.one_shot = true
	death_timer.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(death_timer)
	death_timer.start()
	
	await death_timer.timeout
	death_timer.queue_free()
	GameManager.restart_current_level()



func _on_prevent_dash_zone_body_entered(body: Node2D) -> void:
	# prevent dashing through characters
	if (
		body is Character and
		not body.dead and
		dash_cmd is DashCommand and
		dash_cmd.is_dashing
	):
		dash_cmd.stop(self)
		_start_knockback(body)


func take_damage(amount: int, source: Node) -> void:
	super(amount, source)
	emit_signal("health_changed", health)
	GameManager.damage_player(amount)
	_start_knockback(source)


func _apply_knockback(delta: float) -> void:
	const KNOCKBACK_DECAY := 1000.0
	if abs(_knockback_velocity.x) < 0.01:
		_knockback_velocity.x = 0.0
		return
	velocity.x += _knockback_velocity.x
	_knockback_velocity.x = move_toward(_knockback_velocity.x, 0.0, KNOCKBACK_DECAY * delta)


func _start_knockback(source: Node) -> void:
	if dead:
		_knockback_velocity = Vector2.ZERO
		return

	const KNOCKBACK_SPEED := 420.0
	const KNOCKBACK_VERTICAL := -120.0
	if source is Node2D:
		var dir: float = sign(global_position.x - source.global_position.x)
		_knockback_velocity.x = dir * KNOCKBACK_SPEED
		velocity.y = min(velocity.y, KNOCKBACK_VERTICAL)


func _shoot_left():
	change_facing(Facing.LEFT)
	_attack_ice()


func _shoot_right():
	change_facing(Facing.RIGHT)
	_attack_ice()
