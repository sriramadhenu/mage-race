extends Character

@export var damage := 50

@onready var _floor_ray: RayCast2D = $FloorRay
@onready var _wall_ray: RayCast2D = $WallRay

var _has_collided := false

func _ready() -> void:
	super()
	velocity = Vector2.RIGHT * movement_speed

func _physics_process(_delta: float):
	if dead:
		return
	# we need the below because this node is ready before the parents,
	# which means tile collisions are not loaded and it would cause issues
	if not _has_collided:
		_has_collided = _floor_ray.is_colliding()
		return

	if _wall_ray.is_colliding():
		_rotate_up_wall()
	elif not _floor_ray.is_colliding():
		_rotate_down_wall()

	move_and_slide()

func _rotate_up_wall():
	rotate(-PI / 2.0)
	velocity = velocity.rotated(-PI / 2.0)

	# nudge the position until touching the wall
	var global_down := Vector2.DOWN.rotated(rotation)
	_floor_ray.force_raycast_update()
	while not _floor_ray.is_colliding():
		global_position += global_down
		_floor_ray.force_raycast_update()

func _rotate_down_wall():
	rotate(PI / 2.0)
	velocity = velocity.rotated(PI / 2.0)

	# since _floor_ray is at the pivot, we need to nudge just slightly
	# right so that it will collide on the next _physics_process
	var global_right := Vector2.RIGHT.rotated(rotation)
	global_position += global_right

func command_callback(_cmd_name: String):
	pass # TODO


func _on_animation_finished() -> void:
	if not dead:
		sprite.play("default")

func _on_hurt() -> void:
	sprite.play("hurt")

func _on_death() -> void:
	sprite.play("death")

func _on_hit_box_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(damage, self)
