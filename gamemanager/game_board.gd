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
@onready var level: Level = %Level
#objet qui gère les tours
@onready var turn_manager: TurnManager = %TurnManager

##propriété qui va contenir chaque entité présente présente l'étage en cours
var _units := {}

##les célules sur lesquelles on peut marcher
var _walkable_cells := []

##réference pour du joueur
var _player : Player

func _ready() -> void:
	reinitialize()
	
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
		
		if unit is Player:
			_player = unit
	
	for unit in _units.values():
		if unit is Enemy:
			var enemy  = unit as Enemy
			enemy._player = _player
			enemy.move_requested.connect(_try_to_move_enemy)
	#on fait connaitre au turn_manager les unités qui doivent jouer		
	turn_manager.initialize(_units)
	


func _execute_command(command: Command) -> void:
	command.execute()
	await command.finished

##fonction pour faire bouger un ennemis si le chemin est valide.
func move_unit(unit: Unit, path: PackedVector2Array) -> void:
	if path.is_empty():
		return
	
	#si tout est bon on met à jour la position de l'unité dans le dictionnaire
	_units.erase(unit.cell)
	
	#je crée une command de mouvement pour l'appeler après
	var command := MoveCommand.new(unit,path)
	#on attend que le chemin soit terminé
	await _execute_command(command)
	
	#une fois le mouvement terminé on met à jour la position dans le dico
	_units[unit.cell] = unit
	
##ça c'est la logique pour faire le déplacement 
func _try_move_player(new_cell: Vector2) -> void:
	var walkable_cells = level.get_walkable_cells(_player,_units)
	
	#si la celule qu'on veut n'est pas dedans alors on demande la célule la plus proche
	if not new_cell in _walkable_cells:
		new_cell = grid.get_nearest_walkable_cell(new_cell,walkable_cells)
	
	#je recupère le chemin
	var _path = unit_path.build_path(_player.cell,new_cell,_player.move_range)
	await move_unit(_player, _path)
	turn_manager.on_player_action_done()

func _try_to_move_enemy(_unit_enemy: Unit, target_cell: Vector2) -> void:

	print("enemy try to move")
	var _path = get_path_to_player(_unit_enemy, target_cell)
	print("path of the enemy", _path)
	if not _path.is_empty():
		await move_unit(_unit_enemy,_path)
	else:
		await get_tree().create_timer(0.1).timeout # Une micro pause
		print("l'ennemi peu pas bouger il passe son tour")
		
	_unit_enemy.action_finished.emit()
	
	
##fonction pour retourner un chemin pour l'ennemis
func get_path_to_player(unit: Unit, target_cell) -> PackedVector2Array:
	var enemy_walkable_cells = level.get_walkable_cells(unit, _units)
	
	if target_cell not in enemy_walkable_cells:
		target_cell = grid.get_nearest_walkable_cell(target_cell, enemy_walkable_cells)
		
	if not level.is_cell_walkable(target_cell) or target_cell == unit.cell:
		print("peu pas y aller soit pas marchable ou y'a une unité")
		return PackedVector2Array()
		
	unit_path.initalize(enemy_walkable_cells)
	return unit_path.build_path(unit.cell,target_cell,unit.move_range)
	


##signal connecté quand le cursor clic
func _on_cursor_accept_pressed(cell: Vector2) -> void:
	if not turn_manager.is_player_turn():
		return
	_try_move_player(cell)

#signal connecté quand le cursor bouge sur le plateau
func _on_cursor_moved(new_cell: Vector2) -> void:
	if turn_manager.is_player_turn():
		unit_path.draw_path(_player.cell,new_cell, _player.move_range)


func _on_turn_manager_player_turned() -> void:
	_walkable_cells = level.get_walkable_cells(_player, _units)
	unit_overlay.draw(_walkable_cells)
	unit_path.initalize(_walkable_cells)


func _on_turn_manager_player_turn_finished() -> void:
	_walkable_cells.clear()
	unit_overlay.clear()
	unit_path.stop()
