class_name Player
extends Character 

# player states
var cmd_list: Array[Command]
var _anim_locked := false

var _ice_spell_scene: PackedScene = preload("res://scenes/projectiles/ice_spell.tscn")

func _ready() -> void:
	bind_player_input_commands()
	command_callback("spawn")

func _physics_process(delta: float) -> void:
	if dead:
		return
	# Update dash every frame (important)
	dash_cmd.update(self, delta)

	# If any queued commands exist, process them first
	if len(cmd_list) > 0:
		var command_status: Command.Status = cmd_list.front().execute(self)
		if Command.Status.DONE == command_status:
			cmd_list.pop_front()
		super(delta)
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

func _attack_ice():
	if _anim_locked:
		return
	_anim_locked = true
	sprite.play("cast_forward")

	var facing_dir := 1 if facing == Facing.RIGHT else -1
	var ice_spell: IceSpell = _ice_spell_scene.instantiate()
	ice_spell.ignore = self
	ice_spell.velocity.x *= facing_dir
	ice_spell.global_position = global_position + Vector2(50 * facing_dir, -30)

	get_parent().add_child(ice_spell)

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

func _on_hurt() -> void:
	_anim_locked = true
	sprite.play("hurt")

func _on_death() -> void:
	_anim_locked = true
	sprite.play("death")
