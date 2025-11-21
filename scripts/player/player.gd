extends CharacterBody2D

const WALK_SPEED = 300

@onready var sprite = $AnimatedSprite2D

func _process(_delta: float):
	var dir_x := 0
	if Input.is_action_pressed("player_forward"):
		dir_x += 1
	if Input.is_action_pressed("player_backward"):
		dir_x -= 1

	velocity.x = dir_x * WALK_SPEED
	move_and_slide()

	if dir_x != 0:
		sprite.flip_h = dir_x < 0
		sprite.play("walk")
	else:
		sprite.play("idle")
