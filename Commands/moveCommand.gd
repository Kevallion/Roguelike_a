# Fichier: moveCommand.gd
# Rôle: Encapsule l'action de déplacement d'une unité.
# Contient l'unité à déplacer, le chemin à suivre, et une référence optionnelle
# au GameBoard pour mettre à jour la position logique de l'unité.
class_name MoveCommand extends Command

var unit : Unit
var path : PackedVector2Array
var board : GameBoard

func _init(_unit: Unit, _path: PackedVector2Array, _board: GameBoard = null) -> void:
		unit = _unit
		path = _path
		board = _board
		
func execute() -> void:
	#mettre à jour la position de l'unité sur le plateau
	if board and board.has_method("update_unit_position"):
		board.update_unit_position(unit,path[-1])
	
	unit.is_onAction = true
	unit.walk_along(path)
	unit.walk_finished.connect(_on_finished,CONNECT_ONE_SHOT)
	
func _on_finished() -> void:
	unit.is_onAction = false
	finished.emit()
