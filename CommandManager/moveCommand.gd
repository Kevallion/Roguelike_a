##command pour executer le déplacement de l'unité
class_name MoveCommand extends Command

var unit : Unit
var path : PackedVector2Array

func _init(_unit: Unit, _path: PackedVector2Array) -> void:
		unit = _unit
		path = _path
		
func execute() -> void:
	unit.walk_along(path)
	await unit.walk_finished
	_on_finished()
	
func _on_finished() -> void:
	finished.emit()
