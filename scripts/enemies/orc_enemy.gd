extends Character

const ATTACK_DAMAGE := 20

@onready var _floor_ray := $FloorRaycast
@onready var _attack_zone := $AttackZone

var _anim_locked := false
var _is_attacking := false

func _physics_process(delta: float):
	if dead:
		return

	# if colliding with wall or about to fall off edge
	if is_on_wall() or not _floor_ray.is_colliding():
		_toggle_facing()

	if not _is_attacking:
		velocity.x = movement_speed * _facing_dir()
		if not _anim_locked:
			sprite.play("walk")
	super(delta)

func _toggle_facing():
	var new_facing := Facing.LEFT if facing == Facing.RIGHT else Facing.RIGHT
	change_facing(new_facing)

func _facing_dir():
	if facing == Facing.RIGHT:
		return 1
	else:
		return -1

func change_facing(new_facing: Facing) -> void:
	super(new_facing)
	# flip important zones
	_floor_ray.position.x = abs(_floor_ray.position.x) * _facing_dir()
	_attack_zone.position.x = abs(_attack_zone.position.x) * _facing_dir()

func command_callback(_cmd_name: String):
	pass # TODO

func _on_animation_finished() -> void:
	_anim_locked = false
	_is_attacking = false

func _on_attack_zone_body_entered(body: Node2D) -> void:
	if dead or not body is Player or body.dead:
		return

	_is_attacking = true
	_anim_locked = true
	sprite.play("attack")
	velocity.x = 0
	body.take_damage(ATTACK_DAMAGE)

func _on_hurt() -> void:
	_anim_locked = true
	sprite.play("hurt")

func _on_death() -> void:
	_anim_locked = true
	sprite.play("death")
