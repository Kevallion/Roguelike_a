extends Node

##Variable qui contient les différents AudioStream
var audio_players : Array[AudioStreamPlayer]


##Function pour joueur un son
func play(stream: AudioStream) -> void:
	var audio_player = _get_available_audio_player()
	audio_player.stream = stream
	audio_player.play()

##function qui pour obtnir un lecteur qui ne joue pas de son
func _get_available_audio_player() -> AudioStreamPlayer:

	for audio_player in audio_players:
		if not audio_player.playing:
			return audio_player
	

	return _create_new()

func _create_new() -> AudioStreamPlayer:
	print("creation d'un nouveau fichier audio")
	var audio_player :=  AudioStreamPlayer.new()
	add_child(audio_player)
	audio_players.append(audio_player)
	return audio_player

