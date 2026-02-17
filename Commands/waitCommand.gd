# Fichier: waitCommand.gd
# Rôle: Encapsule une action "d'attente".
# Force une unité à ne rien faire pendant une courte durée. Utile pour les ennemis
# qui ne peuvent pas atteindre le joueur, afin qu'ils passent leur tour.
class_name WaitCommand extends "res://Commands/command.gd"

var unit: Unit
var duration : float


func _init(_receiver: Unit, _duration: float = 0.2) -> void:
	unit = _receiver
	duration = _duration

func execute() -> void:
	await unit.get_tree().create_timer(duration).timeout
	finished.emit()
