# Fichier: audio_manager.gd
# Rôle: Gère la lecture de tous les effets sonores du jeu de manière optimisée.
# Il fonctionne comme un "pool" de lecteurs audio (AudioStreamPlayer).
# Au lieu de créer un nouveau nœud pour chaque son, il réutilise les lecteurs
# qui ont fini de jouer. Si tous les lecteurs sont occupés, il en crée un
# nouveau dynamiquement. Cela évite la création et la suppression constantes de nœuds.

extends Node

##Variable qui contient les différents AudioStream
var audio_players : Array[AudioStreamPlayer]


##Function pour joueur un son
func play(stream: AudioStream) -> void:
	var audio_player = _get_available_audio_player()
	audio_player.stream = stream
	audio_player.play()

##function qui va chercher si un lecteur ne joue pas de son
func _get_available_audio_player() -> AudioStreamPlayer:

	for audio_player in audio_players:
		if not audio_player.playing:
			return audio_player
	

	return _create_new()

##function pour crerrer un nouveau node AudioStreamPlayer
func _create_new() -> AudioStreamPlayer:
	print("creation d'un nouveau fichier audio")
	var audio_player :=  AudioStreamPlayer.new()
	add_child(audio_player)
	audio_players.append(audio_player)
	return audio_player

