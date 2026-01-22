extends Node

#Informer tous les systèmes du jeu qu’un changement d’état a eu lieu.
signal state_changed(old_state, new_state)

enum GAME_STATE {MENU, GAME, PAUSE, GAMEOVER}
var current_state : GAME_STATE


##fonction à appeler pour changer états
func change_state(new_state: GAME_STATE) -> void:
	if new_state == current_state:
		return 
		
	var old_state = current_state
	current_state = new_state
	
	#on prévient quon à changé de scène
	state_changed.emit(old_state,new_state)
	_on_state_entered(current_state)

##fonction pour gérer la logique de changement de sene ou non en fonction de letat
func _on_state_entered(state: GAME_STATE) -> void:
	match state:
		GAME_STATE.MENU:
			pass
		GAME_STATE.GAME:
			pass
		GAME_STATE.PAUSE:
			pass
		GAME_STATE.GAMEOVER:
			Globals.scene_changer.change_scene_to("uid://hhfissgdpxtc")
