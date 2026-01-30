# Fichier: enemy.gd
# Rôle: Définit le comportement et l'Intelligence Artificielle (IA) des unités ennemies.
# Hérite de `Unit`.
#
# Logique de décision (IA):
# La fonction clé est `get_intention()`, qui agit comme le "cerveau" de l'ennemi.
# À chaque tour, elle décide de la meilleure action à entreprendre en retournant un objet `Command`.
# La logique est la suivante:
# 1. Si la vie est critique -> Tenter de fuir (`_get_flee_intention`).
# 2. Sinon, si le joueur est visible ->
#    a. S'il est à portée -> Attaquer (`AttackCommand`).
#    b. Sinon -> Se déplacer vers lui (`_get_move_toward_player_intention`).
# 3. Sinon (joueur non visible) -> Attendre son tour (`WaitCommand`).
#
# Optimisation:
# La variable `is_sleeping` permet de désactiver le traitement de l'ennemi lorsqu'il est
# hors de l'écran (géré par un `VisibleOnScreenNotifier2D`), économisant ainsi des ressources.
class_name Enemy extends Unit


var _player: Player
var is_sleeping : bool = true 
@export var view_range : float = 160.0

## Retourne la commande que l'ennemi souhaite exécuter
func get_intention(board: GameBoard) -> Command:
	if is_heath_critical():
		return  _get_flee_intention(board)
	elif is_player_visible():
		if can_attack_player():
			return AttackCommand.new(self, _player)
		else:
			return _get_move_toward_player_intention(board)

	else:	
		return WaitCommand.new(self, 0.1)
	
		

func is_player_visible() -> bool:
	if is_instance_valid(_player):
		return _player.global_position.distance_to(global_position) < view_range
	else:
		return false

func can_attack_player() -> bool:
	if not is_instance_valid(_player):
		return false
	
	var difference : Vector2 = (_player.cell - self.cell).abs()
	var distance : float = difference.x + difference.y
	return distance <= 1


func is_heath_critical() -> bool:
	if not stat_component:
		return false
	return stat_component.is_heath_critical()
	

func _get_flee_intention(board: GameBoard) -> Command:
	# On récupère les cellules accessibles
	var enemy_walkable_cells = board.environment_level.get_walkable_cells(self, board._units)
	
	# On cherche la cellule la plus éloignée
	var farthest_cells = grid.get_farthest_walkable_cell(cell, enemy_walkable_cells)
	
	board.unit_path.initalize(enemy_walkable_cells)
	var path = board.unit_path.build_path(cell, farthest_cells, move_range)
	
	if path.is_empty():
		# Si bloqué, on attaque si possible, sinon on attend
		if can_attack_player():
			return AttackCommand.new(self, _player)
		else:
			return WaitCommand.new(self,0.1)
	
	return MoveCommand.new(self, path, board)


func _get_move_toward_player_intention(board: GameBoard) -> Command:
	#si le player n'est pas valide on balance un wait
	if not is_instance_valid(_player):
		return WaitCommand.new(self, 0.1)

	var target_cell = grid.get_neareast_cells_around_a_target(cell, _player.cell)
	
	# On utilise la fonction utilitaire du GameBoard
	var path = board.get_path_to_player(self, target_cell)
	
	if path.is_empty():
		return WaitCommand.new(self,0.1)
		
	return MoveCommand.new(self, path, board)


func die() -> void:
	queue_free()
	



func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	is_sleeping = false


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	is_sleeping = true
