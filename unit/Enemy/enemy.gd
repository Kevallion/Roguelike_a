class_name Enemy extends Unit


var _player: Player
var is_sleeping : bool = true 
@export var view_range : float = 160.0
##Cerveau de l'ennemie sans ça il ne fait rien
@export var ai_brain : AiBrain


func initialize(board: GameBoard) -> void:
	if ai_brain:
		ai_brain.initialize(self, board)
	
## Retourne la commande que l'ennemi souhaite exécuter
func get_intention(board: GameBoard) -> Command:
	if is_sleeping or not _is_player_in_view_range() or not ai_brain:
		return WaitCommand.new(self,0.1)
	return ai_brain.get_best_action()
		

func _is_player_in_view_range() -> bool:
	if is_instance_valid(_player):
		return _player.global_position.distance_to(global_position) < view_range
	else:
		return false


func die() -> void:
	queue_free()
	



func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	is_sleeping = false


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	is_sleeping = true
