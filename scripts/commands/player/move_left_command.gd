class_name MoveLeftCommand
extends Command

func execute(character: Character) -> Status:
	if character.dash_cmd.is_dashing:
		return Status.DONE
	var input = -1 * character.movement_speed
	character.velocity.x = input
	character.sprite.flip_h = true
	character.change_facing(Character.Facing.LEFT)
	return Status.DONE
