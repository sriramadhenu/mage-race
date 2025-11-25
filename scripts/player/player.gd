class_name Player
extends Character 

@export var health:int = 100

# player states
var _damaged:bool = false
var _dead:bool = false
var cmd_list : Array[Command]

func _ready() -> void:
	bind_player_input_commands()
	command_callback("spawn")

func _physics_process(delta: float) -> void:
	if _dead:
		return
	# Update dash every frame (important)
	dash_cmd.update(self, delta)

	# If any queued commands exist, process them first
	if len(cmd_list)>0:
		var command_status:Command.Status = cmd_list.front().execute(self)
		#if command_status == Command.Status.ACTIVE:
		if Command.Status.DONE == command_status:
			cmd_list.pop_front()
		super(delta)
		return
	
	var move_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")	
	if Input.is_action_just_pressed("jump"):
		var jump_cmd = JumpCommand.new()
		jump_cmd.execute(self)
	if Input.is_action_just_pressed("dash"):
		dash_cmd.execute(self)
	
	if move_input > 0.1:
		right_cmd.execute(self)
	elif move_input < -0.1:
		left_cmd.execute(self)
	else:
		idle.execute(self)
	
	super(delta)
	
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

func take_damage(dmg: int) -> void:
	health -= dmg
	_damaged = true

	if health <= 0:
		_die()
	else:
		command_callback("hurt")

func _die() -> void:
	_dead = true
	command_callback("death")
	
func resurrect() -> void:
	_dead = false
	health = 100
	command_callback("undeath")
		

func command_callback(cmd_name:String) -> void:
	match cmd_name:
		"jump":
			_play($Audio/jump)
		"dash":
			_play($Audio/dash)
		"hurt":
			_play($Audio/hurt)
		"death":
			_play($Audio/defeat)
		"spawn":
			_play($Audio/spawn)

func _play(player:AudioStreamPlayer2D) -> void:
	if !player.playing:
		player.play()
