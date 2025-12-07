@abstract class_name Character
extends CharacterBody2D

signal direction_change(facing: Facing)
signal hurt()
signal death()
signal resurrect()

const DEFAULT_HEALTH := 100
@export var health := DEFAULT_HEALTH
@export var max_health := DEFAULT_HEALTH

enum Facing {
	LEFT,
	RIGHT
}

var gravity: int = ProjectSettings.get("physics/2d/default_gravity")

const TERMINAL_VELOCITY = 700
const DEFAULT_JUMP_VELOCITY = -500
const DEFAULT_MOVE_VELOCITY = 300

# Movement variables
@export var movement_speed = DEFAULT_MOVE_VELOCITY
@export var jump_velocity = DEFAULT_JUMP_VELOCITY

# Command references
var right_cmd: Command
var left_cmd: Command
var up_cmd: Command
var idle: Command
var dash_cmd: Command

# State flags
var facing: Facing = Facing.RIGHT
var jumping: bool = false
var dead: bool = false

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	change_facing(facing)

func change_facing(new_facing: Facing) -> void:
	facing = new_facing
	sprite.flip_h = (facing == Facing.LEFT)
	direction_change.emit(facing)

func take_damage(damage: int):
	if dead or damage <= 0:
		return

	health -= damage
	if health <= 0:
		dead = true
		health = 0
		death.emit()
	else:
		hurt.emit()

func ressurect():
	if not dead:
		return
	dead = false
	health = max_health
	resurrect.emit()

@abstract func command_callback(cmd_name: String)

func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	_apply_movement(delta)

func _apply_gravity(delta : float) -> void:
	velocity.y = minf(TERMINAL_VELOCITY, velocity.y + gravity * delta)

func _apply_movement(_delta: float):
	move_and_slide()
