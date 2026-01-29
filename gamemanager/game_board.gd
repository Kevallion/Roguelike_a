##Representer et organiser mon plateau, Il connait toutes les entité qui sont sur des célules
##Il peut dire si la célule est occupé our pas
##Les unité peuvent bouger seulement autour de la grille et une à la fois.
##c'est la la glue qui regroupe tout mes composants
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

##réference pour du joueur
var _player : Player
var selected_skill : SkillsData = null

func _ready() -> void:
	reinitialize()
	SignalBus.skill_seleted.connect(_on_skill_selected)
	
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
	

func execute_command(command: Command) -> void:
	command.execute()
	await command.finished

func update_unit_position(unit: Unit, destination_cell: Vector2) -> void:
	_units.erase(unit.cell)
	unit.cell = destination_cell
	_units[destination_cell] = unit

##fonction pour faire bouger un ennemis si le chemin est valide.
func move_unit(unit: Unit, path: PackedVector2Array) -> void:
	if path.is_empty():
		return
	
	var command := MoveCommand.new(unit,path, self)
	#on attend que le chemin soit terminé
	await execute_command(command)
	

	
##ça c'est la logique pour faire le déplacement du player
func _try_move_player(new_cell: Vector2) -> void:
	var walkable_cells = environment_level.get_walkable_cells(_player,_units)
	
	#si la celule qu'on veut n'est pas dedans alors on demande la célule la plus proche
	if not new_cell in _walkable_cells:
		new_cell = grid.get_nearest_walkable_cell(new_cell,walkable_cells)
	
	#je recupère le chemin
	var _path = unit_path.build_path(_player.cell,new_cell,_player.move_range)
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
	
	#calculer la distance pour ensuite vérifier la porté
	var distance = grid.get_manathan_distance(_player.cell,target_cell)
	
	#s'il est à porté il pourra attaquer
	if distance < selected_skill.min_range or distance > selected_skill.max_range:
		return
	
	#on vérifie s'il peu se payer le skill d'abord
	if not _player.can_afford_skill(selected_skill):
		return 
	
	#s'il peu allor il paie
	_player.pay_cost_skill(selected_skill)
	

	match selected_skill.type:
		SkillsData.Skill_type.DAMAGE:
			var command = AttackCommand.new(_player,_units.get(target_cell), selected_skill)
			await execute_command(command)
			turn_manager.on_player_action_done()
		SkillsData.Skill_type.HEAL:
			var command = HealCommand.new(_player,_units.get(target_cell),selected_skill)
			await execute_command(command)
			turn_manager.on_player_action_done()
		SkillsData.Skill_type.BUFF:
			var target_unit: Unit
			
			if selected_skill.target_self:
				target_unit = _player
			else:
				target_unit = _units.get(target_cell)
			var command = BuffCommand.new(_player, target_unit, selected_skill)
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
		_try_cast_skill_player(cell)
	else:
		if unit_at_cell is Enemy:
			_try_attack_player(unit_at_cell)
		elif not _units.has(cell):
			_try_move_player(cell)

#signal connecté quand le cursor bouge sur le plateau
func _on_cursor_moved(new_cell: Vector2) -> void:
	if turn_manager.is_player_turn():
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
		return
	print("Un nouveau sort à été choisi", skill.skill_name)
	selected_skill = skill
