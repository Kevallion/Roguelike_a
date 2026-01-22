##Cette objet doit permettre de géré les tours des entité.
class_name TurnManager extends Node

var _player : Player
var _enemies: Array[Enemy] = []

signal player_turned
signal player_turn_finished
signal player_died

enum TurnState  {PLAYER, ENEMY, BUSY}
var current_state = TurnState.PLAYER

#initialize à besoin de savoir qui sont les enemies et sera appelé par gameboard
func initialize(_units: Dictionary) -> void:
	_enemies.clear()
	_player = null
	transition_to_state(TurnState.PLAYER)
	
	for unit in _units.values():
		if unit is Enemy:
			_enemies.append(unit)
		elif unit is Player:
			_player = unit

func update_enemies(_unit: Enemy) -> void:
	_enemies.erase(_unit)
	
func update_player() -> void:
	_player = null 
	
##fonction pour savoir si c'est le tour du joueur
func is_player_turn() -> bool:
	return current_state == TurnState.PLAYER
	
func on_player_action_done():
	transition_to_state(TurnState.BUSY)
	await _run_enemy_turn()
	if is_instance_valid(_player):
		transition_to_state(TurnState.PLAYER)
	else:
		Globals.state.change_state(Gamestate.GAME_STATE.GAMEOVER)

func _run_enemy_turn() -> void:
	transition_to_state(TurnState.ENEMY)
	
	for enemy in _enemies:
		if enemy.is_sleeping:
			continue
		
		await enemy.take_turn()

func transition_to_state(new_state: TurnState) -> void:
	var old_state = current_state
	current_state = new_state
	
	match old_state:
		TurnState.PLAYER:
			player_turn_finished.emit()
	match current_state:
		TurnState.PLAYER:
			player_turned.emit()
