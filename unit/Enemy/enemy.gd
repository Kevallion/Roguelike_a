##Objet pour réprésenter tout ce que les enemies peuvent faire
class_name Enemy extends Unit

var _player: Player
var is_sleeping := true 
@export var view_range := 160.0

## Retourne la commande que l'ennemi souhaite exécuter
func get_intention(board: GameBoard) -> Command:
	if is_heath_critical():
		return _get_flee_intention(board)
	elif is_player_visible():
		if can_attack_player():
			return AttackCommand.new(self, _player)
		else:
			return _get_move_toward_player_intention(board)
	else:
		return WaitCommand.new(0.1)

func is_player_visible() -> bool:
	if is_instance_valid(_player):
		return _player.global_position.distance_to(global_position) < view_range
	else:
		return false

func can_attack_player() -> bool:
	if not is_instance_valid(_player):
		return false
	var difference := (_player.cell - self.cell).abs()
	var distance := difference.x + difference.y
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
			return WaitCommand.new(0.1)
	
	return MoveCommand.new(self, path, board)

func _get_move_toward_player_intention(board: GameBoard) -> Command:
	if not is_instance_valid(_player):
		return WaitCommand.new(0.1)

	var target_cell = grid.get_neareast_cells_around_a_target(cell, _player.cell)
	
	# On utilise la fonction utilitaire du GameBoard
	var path = board.get_path_to_player(self, target_cell)

	if path.is_empty():
		return WaitCommand.new(0.1)

	return MoveCommand.new(self, path, board)

func die() -> void:
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	is_sleeping = false

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	is_sleeping = true
