##command pour executer le déplacement de l'unité
class_name MoveCommand extends Command

var unit : Unit
var path : PackedVector2Array

func _init(_unit: Unit, _path: PackedVector2Array) -> void:
		unit = _unit
		path = _path
		
func execute() -> void:
	if path.is_empty():
		print("le chemin est vide")
		
	print("je lance la marche")
	unit.is_onAction = true
	var time_to_walk = unit.walk_along(path)
	unit.unit_visual.play_walk_animation(time_to_walk)
	await unit.walk_finished.connect(_on_finished,CONNECT_ONE_SHOT)
	
func _on_finished() -> void:
	print("je finie la marche")
	unit.is_onAction = false
	finished.emit()
