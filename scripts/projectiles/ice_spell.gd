class_name IceSpell
extends Area2D

@export var ignore: Node
@export var velocity := Vector2(750, 0)
@export var damage := 50
@export var max_travel := 1000

@onready var sprite := $AnimatedSprite2D
@onready var _start_global_position := global_position

var _state = "start"

func _physics_process(delta: float):
	if _state == "loop":
		if global_position.distance_to(_start_global_position) > max_travel:
			_end_projectile()
		else:
			global_position += velocity * delta

func _begin_projectile():
	_state = "loop"
	sprite.play("loop")
	reparent(LevelManager.current_level_scene, true)

func _end_projectile():
	_state = "end"
	sprite.play("end")


func _on_animation_finished() -> void:
	if _state == "start":
		_begin_projectile()
	elif _state == "end":
		queue_free() # remove projectile because it's complete

func _on_body_entered(body: Node2D) -> void:
	if _state != "loop" or body == ignore:
		return
	if body is Character:
		if body.dead:
			return
		body.take_damage(damage, self)
	elif body.has_method("take_damage_from_spell"):
		body.take_damage_from_spell(damage)

	_end_projectile()
