extends Node2D

@onready var anim_player: AnimationPlayer = $AnimationPlayer


func destroy():
	if anim_player:
		anim_player.play("destroy")
		await anim_player.animation_finished
	queue_free()
