class_name AiBrain extends Node

#réferences
var _unit: Enemy
var _board: GameBoard

func initilize(unit: Enemy, board: GameBoard) -> void:
	_unit = unit
	_board = board

func get_best_action() -> void:
	var actions: Array = []

func evaluate_consideration(considerations: Array[AiConsideration]) -> float:
	var score : float = 1.0
	
	for consideration : AiConsideration in considerations:
		score = score * consideration.evaluate(_unit,_board._player)
	
	return score
	
func scan_skills(actions: Array) -> void:
	
	if not _unit or not _board or not is_instance_valid(_board._player):
		return
	
	for skill in _unit.skills:
		var action : AiAction = AiAction.new()
		action.command
		
		
