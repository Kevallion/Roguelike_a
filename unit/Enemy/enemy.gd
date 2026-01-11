##Objet pour réprésenter tout ce que les enemies peuvent faire
class_name Enemy extends Unit

signal action_finished
signal move_requested(unit: Unit, target_cell: Vector2)

var _player: Player
@export var view_range := 160.0

##fonction à remplir assap
func take_turn() -> void:
	if is_heath_critical():
		await flee()
	elif is_player_visible():
		if can_attack_player():
			await attack_player()
		else:
			await move_toward_player()
	else:
		await patrol()
		

func is_player_visible() -> bool:
	return _player.global_position.distance_to(global_position) < view_range

func can_attack_player() -> bool:
	var difference := (_player.cell - self.cell).abs()
	var distance := difference.x + difference.y
	return distance <= 1

func is_heath_critical() -> bool:
	return curr_health < critical_health

func patrol() -> void:
	print("je patrouille")
	await get_tree().create_timer(0.1).timeout
	action_finished.emit()

func flee() -> void:
	print("prend la fuite")
	await get_tree().create_timer(0.1).timeout
	action_finished.emit()
	
func attack_player() -> void:
	print("j'attaque le joueur")
	await get_tree().create_timer(0.1).timeout
	action_finished.emit()
	
func wait() -> void:
	print("j'attend un peu")
	await get_tree().create_timer(0.1).timeout
	action_finished.emit()
	
func move_toward_player():
	print("Enemy is moving toward player")
	var target_cell = grid.get_neareast_cells_around_a_target(self.cell, _player.cell)
	move_requested.emit(self, target_cell)
	await action_finished
