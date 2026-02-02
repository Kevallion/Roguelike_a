class_name AI_Brain extends RefCounted

@export var considerations: Array[AI_Consideration] = []

# Références
var _unit: Enemy
var _board: GameBoard

# Dictionnaires de considérations par défaut pour chaque type d'action
var _con_move_chase: Array[AI_Consideration] = []
var _con_move_flee: Array[AI_Consideration] = []
var _con_attack: Array[AI_Consideration] = []
var _con_heal: Array[AI_Consideration] = []

func initialize(unit: Enemy, board: GameBoard) -> void:
	_unit = unit
	_board = board
	_setup_default_considerations()

func decide() -> Command:
	var options: Array[AI_Action] = []

	# 1. Scanner les sorts
	options.append_array(_scan_skills())

	# 2. Scanner les mouvements
	options.append_array(_scan_movement())

	# 3. Choisir la meilleure option
	if options.is_empty():
		return WaitCommand.new(_unit, 0.1)

	# Mélange aléatoire pour casser les égalités parfaites et donner un côté plus naturel
	options.shuffle()

	# Tri décroissant par score
	options.sort_custom(func(a, b): return a.score > b.score)

	var best_option = options[0]

	# Debug log
	# print("AI [", _unit.name, "] decided: ", best_option.command.get_class(), " Score: ", best_option.score)

	if best_option.score <= 0.0:
		return WaitCommand.new(_unit, 0.1)

	return best_option.command

func _score_option(context: Dictionary, consideration_list: Array[AI_Consideration]) -> float:
	if consideration_list.is_empty():
		return 0.0

	var final_score = 1.0
	var has_valid_score = false

	for con in consideration_list:
		var score = con.evaluate(context)
		final_score *= score # Multiplication des scores (fuzzy logic AND)
		has_valid_score = true

		# Si un critère est à 0, l'action est impossible/inutile
		if final_score == 0:
			return 0.0

	return final_score if has_valid_score else 0.0

func _scan_skills() -> Array[AI_Action]:
	var actions: Array[AI_Action] = []

	if not _unit or not _board or not is_instance_valid(_unit._player):
		return actions

	for skill in _unit.skills:
		if not _unit.can_afford_skill(skill):
			continue

		var dist = _board.grid.get_manathan_distance(_unit.cell, _unit._player.cell)

		# Vérification simple de portée
		if dist >= skill.min_range and dist <= skill.max_range:
			var cmd: Command
			var cons: Array[AI_Consideration] = []
			var ctx = { "unit": _unit, "target": _unit._player, "board": _board, "skill": skill }

			match skill.type:
				SkillsData.Skill_type.DAMAGE:
					cmd = AttackCommand.new(_unit, _unit._player, skill)
					cons = _con_attack

				SkillsData.Skill_type.HEAL:
					# On suppose target_self pour l'instant pour simplifier
					if skill.target_self:
						cmd = HealCommand.new(_unit, _unit, skill)
						cons = _con_heal

				SkillsData.Skill_type.BUFF:
					# TODO: Ajouter support Buff
					pass

			if cmd:
				var score = _score_option(ctx, cons)
				if score > 0:
					actions.append(AI_Action.new(cmd, score))

	return actions

func _scan_movement() -> Array[AI_Action]:
	var actions: Array[AI_Action] = []

	if not _unit or not _board or not is_instance_valid(_unit._player):
		return actions

	var ctx = { "unit": _unit, "target": _unit._player, "board": _board }

	# --- Option 1: Poursuivre le joueur ---
	var chase_score = _score_option(ctx, _con_move_chase)

	if chase_score > 0:
		var target_cell = _board.grid.get_neareast_cells_around_a_target(_unit.cell, _unit._player.cell)
		var path_to_player = _board.get_path_to_player(_unit, target_cell)

		if not path_to_player.is_empty():
			var move_cmd = MoveCommand.new(_unit, path_to_player, _board)
			actions.append(AI_Action.new(move_cmd, chase_score))

	# --- Option 2: Fuir ---
	var flee_score = _score_option(ctx, _con_move_flee)

	if flee_score > 0:
		var enemy_walkable_cells = _board.environment_level.get_walkable_cells(_unit, _board._units)
		var farthest_cells = _board.grid.get_farthest_walkable_cell(_unit.cell, enemy_walkable_cells)

		_board.unit_path.initalize(enemy_walkable_cells)
		var flee_path = _board.unit_path.build_path(_unit.cell, farthest_cells, _unit.move_range)

		if not flee_path.is_empty():
			var flee_cmd = MoveCommand.new(_unit, flee_path, _board)
			actions.append(AI_Action.new(flee_cmd, flee_score))

	return actions

func _setup_default_considerations() -> void:
	# Ici on construit les "personnalités" par défaut en assemblant des courbes
	# C'est ce qui remplace la logique hardcodée par une logique modulaire

	# --- Courbes réutilisables ---
	var curve_linear_up = Curve.new() # /
	curve_linear_up.add_point(Vector2(0, 0))
	curve_linear_up.add_point(Vector2(1, 1))

	var curve_linear_down = Curve.new() # \
	curve_linear_down.add_point(Vector2(0, 1))
	curve_linear_down.add_point(Vector2(1, 0))

	# Curve améliorée pour l'attaque : ne descend jamais à 0
	var curve_execution = Curve.new()
	curve_execution.add_point(Vector2(0, 1.0)) # 0% PV = 1.0 Score (Tuer !)
	curve_execution.add_point(Vector2(1, 0.2)) # 100% PV = 0.2 Score (Taper quand même)

	var curve_threshold_low = Curve.new() # _|
	curve_threshold_low.add_point(Vector2(0, 1))
	curve_threshold_low.add_point(Vector2(0.3, 1))
	curve_threshold_low.add_point(Vector2(0.31, 0))
	curve_threshold_low.add_point(Vector2(1, 0))

	# --- 1. CHASE (Poursuite) ---
	# On veut poursuivre si on a de la vie (SelfHealth -> High)
	var con_chase_health = Con_SelfHealth.new()
	con_chase_health.curve = curve_linear_up # Plus j'ai de vie, plus je chasse
	con_chase_health.weight = 1.0
	_con_move_chase.append(con_chase_health)

	# --- 2. FLEE (Fuite) ---
	# On veut fuir si on a PEU de vie (SelfHealth -> Low)
	var con_flee_health = Con_SelfHealth.new()
	con_flee_health.curve = curve_threshold_low # Score max si vie < 30%, sinon 0
	con_flee_health.weight = 2.0 # Priorité très haute
	_con_move_flee.append(con_flee_health)

	# --- 3. ATTACK (Attaque) ---
	# On attaque si l'ennemi est là.
	# Modification ici pour éviter que l'IA ne fasse rien si le joueur est full life
	var con_attack_kill = Con_TargetHealth.new()
	con_attack_kill.curve = curve_execution # Utilise la nouvelle courbe qui ne va pas à 0
	con_attack_kill.weight = 1.2
	_con_attack.append(con_attack_kill)

	# --- 4. HEAL (Soin) ---
	# On se soigne si on a peu de vie
	var con_heal_self = Con_SelfHealth.new()
	con_heal_self.curve = curve_linear_down # Moins j'ai de vie, plus je veux soigner
	con_heal_self.weight = 1.5
	_con_heal.append(con_heal_self)
