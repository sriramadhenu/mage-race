extends Node

@onready var music: AudioStreamPlayer2D = $music

func play():
	if not music.playing:
		music.play()

func play_level_music():
	var stream = preload("res://assets/audio/music/bg_music2.mp3")
	stream.loop = true
	music.stream = stream
	music.play()

func stop():
	music.stop()
