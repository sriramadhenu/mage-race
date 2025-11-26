class_name Character
extends CharacterBody2D

signal CharacterDirectionChange(facing:Facing)

enum Facing {
	LEFT,
	RIGHT
}

var gravity: int = ProjectSettings.get("physics/2d/default_gravity")
var _horizontal_input: float

const TERMINAL_VELOCITY = 700
const DEFAULT_JUMP_VELOCITY = -400
const DEFAULT_MOVE_VELOCITY = 300

# Movement variables
var movement_speed = DEFAULT_MOVE_VELOCITY
var jump_velocity = DEFAULT_JUMP_VELOCITY

# Command references
var right_cmd: Command
var left_cmd: Command
var up_cmd: Command
var idle: Command
var dash_cmd: Command

# State flags
var facing: Facing = Facing.RIGHT
var jumping: bool = false

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var dialogue_box: DialogueBox = %DialogueBox

func _ready() -> void:
	jumping = false
	
	change_facing(facing)
	
func move(value: float) -> void:
	"""Set horizontal input direction"""
	_horizontal_input = value

func change_facing(new_facing: Facing) -> void:
	facing = new_facing
	sprite.flip_h = (facing == Facing.LEFT)
	emit_signal("CharacterDirectionChange", facing)

func command_callback(_name:String) -> void:
	pass

func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	_apply_movement(delta)

func _apply_movement(_delta: float):
	move_and_slide()

func _apply_gravity(delta : float) -> void:
	velocity.y = minf(TERMINAL_VELOCITY, velocity.y + gravity * delta)
