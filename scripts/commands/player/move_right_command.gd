class_name MoveRightCommand
extends Command

func execute(character: Character) -> Status:
	if character.dash_cmd.is_dashing:
		return Status.DONE
	var input = character.movement_speed
	character.velocity.x = input
	character.change_facing(Character.Facing.RIGHT)
	if character.is_on_floor() and not character.jumping:
		character.command_callback("walk")
	return Status.DONE
