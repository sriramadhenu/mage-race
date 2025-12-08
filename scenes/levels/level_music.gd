extends Node

@onready var player: AudioStreamPlayer2D = $level_music

func play():
	if not player.playing:
		player.play()

func stop():
	player.stop()
