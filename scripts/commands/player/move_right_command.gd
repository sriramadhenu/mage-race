class_name MoveRightCommand
extends Command

func execute(character: Character) -> Status:
	if character.dash_cmd.is_dashing:
		return Status.DONE
	var input = character.movement_speed
	character.velocity.x = input
	character.sprite.flip_h = false
	character.change_facing(Character.Facing.RIGHT)
	return Status.DONE
