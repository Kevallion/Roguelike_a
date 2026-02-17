class_name AiBrain extends Node

#réferences
var _unit: Enemy
var _board: GameBoard

@export var move_considerations: Array[AiConsideration]
@export var flee_considerations: Array[AiConsideration]

func initialize(unit: Enemy, board: GameBoard) -> void:
	_unit = unit
	_board = board

##fonction pour retourner la meilleur action à entreprendre
func get_best_action() -> Command:
	var actions: Array = []
	
	#je me tout les action possible dans un tableau
	actions.append_array(scan_skills())
	actions.append_array(scan_move())
	
	var best_action : AiAction = null
	if actions.is_empty():
		return WaitCommand.new(_unit,0.1)
	
	for action: AiAction in actions:
		if best_action == null:
			best_action = action
		elif action.score > best_action.score:
			best_action = action
	
	#Debug Log
	print("AI [", _unit.name, "] decided: ", best_action.name, " Score: ", best_action.score)
	if best_action.score <= 0.0:
		return WaitCommand.new(_unit, 0.1)
		
	return best_action.command
	
	
	
		
##fonction qui va evaluer chaque options considéré
func evaluate_consideration(considerations: Array[AiConsideration]) -> float:
	var score : float = 1.0
	
	for consideration : AiConsideration in considerations:
		score = score * consideration.evaluate(_unit,_board._player)
	
	return score
	
	
##fonction pour scanner les compétences et envoyé une commande et  score selon la considérations
func scan_skills() -> Array[AiAction]:
	#contiens les actions possibles
	var actions : Array[AiAction] = []
	
	#on arete si ya un problème
	if not _unit or not _board or not is_instance_valid(_board._player):
		return actions
		
	for skill in _unit.skills:
		if not _unit.can_afford_skill(skill):
			continue
			
		var cmd : Command
		var score : float
		var action_name : String 
		var dist = _board.grid.get_manathan_distance(_unit.cell, _unit._player.cell)
		
		# Vérification simple de portée
		if dist >= skill.min_range and dist <= skill.max_range:
			match skill.type:
				SkillsData.Skill_type.DAMAGE:
					cmd = AttackCommand.new(_unit,_board._player,skill)
					action_name = "attaque"
				SkillsData.Skill_type.HEAL:
					cmd = HealCommand.new(_unit,_unit,skill)
					action_name = "heal"
				SkillsData.Skill_type.BUFF:
					cmd = BuffCommand.new(_unit,_unit,skill)
					action_name = "buff"
					
			
			score = evaluate_consideration(skill.considerations)
			var action : AiAction = AiAction.new(cmd, score, action_name)
			actions.append(action)
		
		
	return actions
		

##function pour savoir si je dois aller au contact our fuir
func scan_move() -> Array[AiAction]:
	#contiens les actions possibles
	var actions : Array[AiAction] = []
	var score : float
	var path : PackedVector2Array
	var cmd : Command
	var action_name : String 
	
	#on arette si ya un problème
	if not _unit or not _board or not is_instance_valid(_board._player):
		return actions
	
	
	##option 1 poursuivre le joueur
	# Génération du chemin vers le joueur
	var target_cell = _unit.grid.get_neareast_cells_around_a_target(_unit.cell,_board._player.cell)
	path = _board.get_path_to_player(_unit,target_cell)
	if not path.is_empty():
		cmd = MoveCommand.new(_unit,path,_board)
		score = evaluate_consideration(move_considerations)
		action_name = "move toward player"
		actions.append(AiAction.new(cmd,score,action_name))
	
	##option 2 prendre la fuite ou séloigner
	# On récupère les cellules accessibles
	var enemy_walkable_cells = _board.environment_level.get_walkable_cells(_unit, _board._units)
	
	# On cherche la cellule la plus éloignée
	var farthest_cells = _board.grid.get_farthest_walkable_cell(_unit.cell, enemy_walkable_cells)
	
	_board.unit_path.initalize(enemy_walkable_cells)
	path = _board.unit_path.build_path(_unit.cell, farthest_cells, _unit.move_range)
	
	if not path.is_empty():
		cmd = MoveCommand.new(_unit,path,_board)
		score = evaluate_consideration(flee_considerations)
		action_name = "flee away from player"
		actions.append(AiAction.new(cmd,score, action_name))
	
	return actions
