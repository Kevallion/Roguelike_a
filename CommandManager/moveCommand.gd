##command pour executer le déplacement de l'unité
class_name MoveCommand extends Command

var unit : Unit
var path : PackedVector2Array
var board : Node2D

func _init(_unit: Unit, _path: PackedVector2Array, _board: Node2D = null) -> void:
		unit = _unit
		path = _path
		board = _board
		
func execute() -> void:
	if board and board.has_method("update_unit_position"):
		board.update_unit_position(unit, path[-1])

	unit.is_onAction = true
	unit.walk_along(path)
	unit.walk_finished.connect(_on_finished,CONNECT_ONE_SHOT)
	
func _on_finished() -> void:
	unit.is_onAction = false
	finished.emit()
