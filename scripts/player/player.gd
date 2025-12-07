class_name Player
extends Character 

# player states
var cmd_list: Array[Command]
var _anim_locked := false
var _is_casting := false
var _is_dying := false
var _ice_spell_scene: PackedScene = preload("res://scenes/projectiles/ice_spell.tscn")

signal health_changed(new_hp)

func _ready() -> void:
	health = 5
	max_health = 5
	bind_player_input_commands()
	command_callback("spawn")
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
		if randi() % 3 == 0:
			_spawn_dash_ghost()
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
	if Input.is_action_just_pressed("dash"):
		dash_cmd.execute(self)
	if Input.is_action_just_pressed("attack_ice"):
		_attack_ice()

	var move_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
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
	if not _is_casting:
		super(new_facing)


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
		"hurt": player = $Audio/hurt
		"death": player = $Audio/defeat
		"spawn": player = $Audio/spawn
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


func take_damage(amount: int) -> void:
	super(amount)
	emit_signal("health_changed", health)
	GameManager.damage_player(amount)
