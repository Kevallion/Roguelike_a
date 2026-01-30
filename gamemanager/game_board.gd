# Fichier: game_board.gd
# Rôle: C'est la classe centrale qui orchestre l'ensemble du plateau de jeu.
# Elle agit comme la "colle" qui lie tous les systèmes principaux. Ses responsabilités sont:
# - Gérer les unités: Elle maintient un dictionnaire de toutes les unités (joueur, ennemis)
#   présentes sur le plateau et connaît leur position.
# - Exécution des commandes: Elle centralise l'exécution de toutes les actions via le Command Pattern
#   (déplacement, attaque, sorts...).
# - Interaction du joueur: Elle interprète les entrées du joueur (clics de souris) pour
#   déclencher les actions correspondantes (déplacer, attaquer, lancer un sort).
# - Coordination: Elle fait le lien entre la grille logique (Grid), le gestionnaire de tours (TurnManager)
#   et les informations du niveau (EnvironmentLevel) pour s'assurer que les règles du jeu sont respectées.

class_name GameBoard extends Node2D



#on connect la grille
@export var grid: Grid = preload("res://Utils/Grid.tres")
#tilemap qui va me servir à afficher du debug visuel pour le joueur
@onready var unit_overlay: Unit_Overlay = %Unit_overlay
#objet qui permet d'avoir le chemin de l'unité
@onready var unit_path: Unit_Path = %UnitPath
#objet qui connait le niveau et les déplacement possible
@onready var environment_level: EnvironmentLevel = %EnvironmentLevel
#objet qui gère les tours
@onready var turn_manager: TurnManager = %TurnManager

##propriété qui va contenir chaque entité présente présente l'étage en cours
var _units := {}

##les célules sur lesquelles on peut marcher
var _walkable_cells := []

##celule des skills
var skill_cells_range := []	

##réference pour du joueur
var _player : Player
var selected_skill : SkillsData = null

func _ready() -> void:
	reinitialize()
	SignalBus.skill_selected.connect(_on_skill_selected)
	
##function appeler pour vidé toutes les entité connue et obtenir les nouvelles.
func reinitialize() -> void:
	#supprimer toute les unité référencer
	_units.clear()
	_player = null 
	
	for child in get_children():
		var unit = child as Unit
		if not unit:
			continue
		_units[unit.cell] = unit 
		unit.stat_component.health_depleted.connect(update_units)
		
		if unit is Player:
			_player = unit
	
	for unit in _units.values():
		if unit is Enemy:
			var enemy  = unit as Enemy
			enemy._player = _player
		
			
			
	#on fait connaitre au turn_manager les unités qui doivent jouer		
	turn_manager.initialize(_units, self)
	

##notre command qui va exécuté la commande 
func execute_command(command: Command) -> void:
	command.execute()
	await command.finished

##fonction pour mettre à jour la position d'une unité sur le plateau
func update_unit_position(unit: Unit, destination_cell: Vector2) -> void:
	_units.erase(unit.cell)
	unit.cell = destination_cell
	_units[destination_cell] = unit
	
##fonction pour faire bouger un ennemis si le chemin est valide.
func move_unit(unit: Unit, path: PackedVector2Array) -> void:
	if path.is_empty():
		return

	#je crée une command de mouvement pour l'appeler après
	var command := MoveCommand.new(unit, path, self)
	
	#on attend que la command soit éxecuté
	await execute_command(command)
	

	
##ça c'est la logique pour faire le déplacement du player
func _try_move_player(new_cell: Vector2) -> void:
	var walkable_cells = environment_level.get_walkable_cells(_player,_units)
	
	#si la celule qu'on veut n'est pas dedans alors on demande la célule la plus proche
	if not new_cell in _walkable_cells:
		print("not in walkable cells")
		new_cell = grid.get_nearest_walkable_cell(new_cell,walkable_cells)
		print("new cell", new_cell)
	
	if new_cell == _player.cell:
		return
	
	
	#je recupère le chemin
	var _path = unit_path.build_path(_player.cell,new_cell,_player.move_range)
	print(_path)
	await move_unit(_player, _path)
	turn_manager.on_player_action_done()


##function qui essaie d'attaquer l'ennemie	
func _try_attack_player(target_enemy: Unit) -> void:
	var distance := grid.get_manathan_distance(_player.cell, target_enemy.cell)	
	var attack_range := 1
	if distance <= attack_range:
		var command = AttackCommand.new(_player,target_enemy)
		await execute_command(command)
		turn_manager.on_player_action_done()
	else:
		_try_move_player(target_enemy.cell)



##fonction qui va essayer de lancer le sort du joueur
func _try_cast_skill_player(target_cell: Vector2) -> void:
	var skill = selected_skill
	Globals.signalBus.skill_selected.emit(null)

	#calculer la distance pour ensuite vérifier la porté
	var distance = grid.get_manathan_distance(_player.cell,target_cell)
	
	#s'il est à porté il pourra attaquer
	if distance < skill.min_range or distance > skill.max_range:
		print('hors distance')
		return
	
	#on vérifie s'il peu se payer le skill d'abord
	if not _player.can_afford_skill(skill):
		print("n'a pas de ressource sufisante")
		return 
	
	#s'il peu allor il paie
	_player.pay_cost_skill(skill)
	

	match skill.type:
		SkillsData.Skill_type.DAMAGE:
			var command = AttackCommand.new(_player,_units.get(target_cell), skill)
			await execute_command(command)
			turn_manager.on_player_action_done()
		SkillsData.Skill_type.HEAL:
			var command = HealCommand.new(_player,_units.get(target_cell),skill)
			await execute_command(command)
			turn_manager.on_player_action_done()
		SkillsData.Skill_type.BUFF:
			print("buff de sort lancé")
			var target_unit: Unit
			
			if skill.target_self:
				target_unit = _player
			else:
				target_unit = _units.get(target_cell)
			var command = BuffCommand.new(_player, target_unit, skill)
			await execute_command(command)
			turn_manager.on_player_action_done()
		
##fonction pour retourner un chemin pour l'ennemis
func get_path_to_player(unit: Unit, target_cell) -> PackedVector2Array:
	var enemy_walkable_cells = environment_level.get_walkable_cells(unit, _units)
	
	if target_cell not in enemy_walkable_cells:
		target_cell = grid.get_nearest_walkable_cell(target_cell, enemy_walkable_cells)
		
	if not environment_level.is_cell_walkable(target_cell) or target_cell == unit.cell:
		print("peu pas y aller soit pas marchable meme que l'unité une unité")
		return PackedVector2Array()
		
	unit_path.initalize(enemy_walkable_cells)
	return unit_path.build_path(unit.cell,target_cell,unit.move_range)
	

func update_units(unit: Unit) -> void:
	_units.erase(unit.cell)
	if unit is Player:
		turn_manager.update_player()
	else:
		turn_manager.update_enemies(unit)

	unit.die()

##signal connecté quand le cursor clic
func _on_cursor_accept_pressed(cell: Vector2) -> void:
	if not turn_manager.is_player_turn() or _player.is_onAction:
		return
	
	var unit_at_cell = _units.get(cell)
	if selected_skill:
		print('essaie de lancer un sort')
		_try_cast_skill_player(cell)
	else:
		if unit_at_cell is Enemy:
			_try_attack_player(unit_at_cell)
		elif not _units.has(cell):
			_try_move_player(cell)

#signal connecté quand le cursor bouge sur le plateau
func _on_cursor_moved(new_cell: Vector2) -> void:
	if turn_manager.is_player_turn():
		

		if selected_skill != null:
			match selected_skill.aoe_shape:
				SkillsData.AOE_Shape.CIRCLE:
					var circle_cells = grid.get_cells_in_circle(new_cell, selected_skill.aoe_size)
					unit_overlay.draw_impact(circle_cells)
				SkillsData.AOE_Shape.CROSS:
					var cross_cells = grid.get_cells_in_cross(new_cell, selected_skill.aoe_size)
					unit_overlay.draw_impact(cross_cells)
				SkillsData.AOE_Shape.SQUARE:
					var square_cells = grid.get_cells_in_square(new_cell, selected_skill.aoe_size)
					unit_overlay.draw_impact(square_cells)
				SkillsData.AOE_Shape.POINT:
					if skill_cells_range.has(new_cell):
						unit_overlay.draw_impact([new_cell])
		else:
			unit_path.draw_path(_player.cell,new_cell, _player.move_range)




func _on_turn_manager_player_turned() -> void:
	_walkable_cells = environment_level.get_walkable_cells(_player, _units)
	unit_overlay.draw(_walkable_cells)
	unit_path.initalize(_walkable_cells)
	_player.is_onAction = false


func _on_turn_manager_player_turn_finished() -> void:
	_walkable_cells.clear()
	unit_overlay.clear()
	unit_path.stop()

func _on_skill_selected(skill: SkillsData) -> void:
	if skill  == null:
		selected_skill = null
		unit_overlay.clear_attack()
		unit_overlay.clear_impact()
		skill_cells_range.clear()
		unit_overlay.move_layer.visible = true
		
		return
	unit_overlay.move_layer.visible = false
	skill_cells_range = grid.get_cells_in_circle(_player.cell, skill.max_range)
	unit_overlay.draw_range(skill_cells_range)
	print("Un nouveau sort à été choisi", skill.skill_name)
	selected_skill = skill
