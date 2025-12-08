@abstract class_name Character
extends CharacterBody2D

signal direction_change(facing: Facing)
signal hurt()
signal death()
signal resurrect()

@export var health := 100
@export var max_health := health

enum Facing {
	LEFT,
	RIGHT
}

var gravity: float = ProjectSettings.get("physics/2d/default_gravity")

const DEFAULT_MOVE_VELOCITY := 300
const DEFAULT_TERMINAL_VELOCITY := 700
const DEFAULT_JUMP_VELOCITY := -500
const DEFAULT_FALL_GRAVITY_SCALE := 1.5
const PUSH_FORCE := 20
const MAX_PUSH_VELOCITY := 150


# Movement variables
@export var movement_speed := DEFAULT_MOVE_VELOCITY
@export var terminal_velocity := DEFAULT_TERMINAL_VELOCITY
@export var jump_velocity := DEFAULT_JUMP_VELOCITY
@export var fall_gravity_scale := DEFAULT_FALL_GRAVITY_SCALE

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

func take_damage(damage: int, _source: Node):
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
	
	# Handle pushable objects
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collision_block = collision.get_collider()
		
		# Check if collision_block is still valid
		if not is_instance_valid(collision_block):
			continue
		
		# Also check if it's safe to call methods on it
		if not collision_block.is_inside_tree():
			continue
		
		# Check if we can safely call is_in_group
		var is_pushable = false
		if collision_block.has_method("is_in_group"):
			is_pushable = collision_block.is_in_group("PushableBlock")
		
		if is_pushable:
			# Check if it has physics methods
			if collision_block.has_method("get_linear_velocity") and collision_block.has_method("apply_central_impulse"):
				var block_velocity = collision_block.get_linear_velocity()
				if abs(block_velocity.x) < MAX_PUSH_VELOCITY:
					collision_block.apply_central_impulse(collision.get_normal() * -PUSH_FORCE)
			
	_apply_movement(delta)

func _apply_gravity(delta : float) -> void:
	var instant_gravity := self.gravity
	if velocity.y > 0: # falling
		instant_gravity *= fall_gravity_scale
	velocity.y = minf(terminal_velocity, velocity.y + instant_gravity * delta)

func _apply_movement(_delta: float):
	move_and_slide()
