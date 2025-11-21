extends CharacterBody2D

const WALK_SPEED = 100

@onready var sprite := $AnimatedSprite2D
@onready var floor_ray_right := $FloorRaycastRight
@onready var floor_ray_left := $FloorRaycastLeft

var dir_x := -1

func _process(_delta: float):
	velocity.x = dir_x * WALK_SPEED
	move_and_slide()
	
	# if colliding with wall
	if is_on_wall():
		dir_x = -dir_x
	
	# if about to fall off edge
	var forward_ray: RayCast2D = floor_ray_left if dir_x < 0 else floor_ray_right
	if not forward_ray.is_colliding():
		dir_x = -dir_x
	
	if dir_x != 0:
		sprite.flip_h = dir_x < 0
		sprite.play("walk")
	else:
		sprite.play("idle")
