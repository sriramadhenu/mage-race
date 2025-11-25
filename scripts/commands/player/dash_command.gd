class_name DashCommand
extends Command

# dash states
var is_dashing: bool = false
var can_dash: bool = true
var dash_timer: float = 0.0
var cooldown_timer: float = 0.0
var dash_direction: Vector2 = Vector2.ZERO

const DASH_SPEED := 500.0
const DASH_DURATION := 0.7
const DASH_COOLDOWN := 1.0


func execute(character: Character) -> Status:
	# cannot dash if in cooldown or already dashing
	if not can_dash or is_dashing:
		return Status.ERROR
	
	# determine dash direction based on character facing
	if character.facing == Character.Facing.RIGHT:
		dash_direction = Vector2.RIGHT
	else:
		dash_direction = Vector2.LEFT

	# Activate dash
	is_dashing = true
	can_dash = false
	dash_timer = DASH_DURATION
	character.velocity.x = dash_direction.x * DASH_SPEED
	character.command_callback("dash")

	return Status.DONE


func update(character: Character, delta: float) -> void:
	# if dashing, reduce timer
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0.0:
			is_dashing = false
			character.velocity.x = 0
			cooldown_timer = DASH_COOLDOWN

	# Cooldown handling
	if not can_dash:
		cooldown_timer -= delta
		if cooldown_timer <= 0.0:
			can_dash = true
