extends AudioStreamPlayer

const tutorial_music = preload("res://assets/audio/music/Remembrance.mp3")

func _play_music(music: AudioStream, volume = -16.0):
	if stream == music:
		return

	stream = music
	volume_db = volume
	play()
	
func play_music_tutorial():
	_play_music(tutorial_music)
