extends AudioStreamPlayer

const tutorial_music = preload("res://assets/audio/music/Remembrance.mp3")
const time_level_music = preload("res://assets/audio/music/TimeLVL(JungleTheme).mp3")
const space_level_music = preload("res://assets/audio/music/Space.mp3")
const final_boss_music = preload("res://assets/audio/music/FinalBoss.mp3")

func _play_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return

	stream = music
	volume_db = volume
	
	# Set looping
	if stream is AudioStream:
		stream.loop = true
		
	play()
	
func play_music_tutorial():
	_play_music(tutorial_music)

func play_music_timelevel():
	_play_music(time_level_music)
	
func play_music_spacelevel():
	_play_music(space_level_music)
	
func play_music_finalboss():
	_play_music(final_boss_music)
