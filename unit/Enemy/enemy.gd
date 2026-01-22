##Objet pour réprésenter tout ce que les enemies peuvent faire
class_name Enemy extends Unit

signal action_finished
signal move_requested(unit: Unit, target_cell: Vector2)
signal attack_requested(unit: Unit)
signal flee_requested(unit: Unit)

var _player: Player
var is_sleeping := true 
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
	if is_instance_valid(Player):
		return _player.global_position.distance_to(global_position) < view_range
	else:
		return false

func can_attack_player() -> bool:
	var difference := (_player.cell - self.cell).abs()
	var distance := difference.x + difference.y
	return distance <= 1


func is_heath_critical() -> bool:
	if not stat_component:
		return false
	return stat_component.is_heath_critical()
	
func patrol() -> void:
	await get_tree().create_timer(0.1).timeout
	action_finished.emit()

func flee() -> void:
	flee_requested.emit(self)
	await action_finished

	
func attack_player() -> void:
	attack_requested.emit(self)
	await action_finished
	
func wait() -> void:
	print("j'attend un peu")
	await get_tree().create_timer(0.1).timeout
	action_finished.emit()
	
func move_toward_player():
	var target_cell = grid.get_neareast_cells_around_a_target(self.cell, _player.cell)
	move_requested.emit(self, target_cell)
	await action_finished

func die() -> void:
	queue_free()
	



func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	is_sleeping = false


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	is_sleeping = true
