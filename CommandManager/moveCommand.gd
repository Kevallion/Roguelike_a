##command pour executer le déplacement de l'unité
class_name MoveCommand extends Command

var unit : Unit
var path : PackedVector2Array

func _init(_unit: Unit, _path: PackedVector2Array) -> void:
		unit = _unit
		path = _path
		
func execute() -> void:
	unit.is_onAction = true
	unit.walk_along(path)
	unit.walk_finished.connect(_on_finished,CONNECT_ONE_SHOT)
	
func _on_finished() -> void:
	unit.is_onAction = false
	finished.emit()
