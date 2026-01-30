# Fichier: player.gd
# Rôle: Représente le joueur.
# Cette classe hérite de `Unit` et y ajoute la logique spécifique au joueur.
# Sa principale responsabilité est de communiquer avec le reste du jeu via le `SignalBus`
# lorsque des événements majeurs le concernant surviennent, comme sa mort (`player_died`).
class_name Player extends Unit


func _ready() -> void:
	super._ready()
	stat_component.health_depleted.connect(_on_health_depleted)
	SignalBus.skill_inited.emit(skills)
	
func _on_health_depleted(unit: Unit) -> void:
	SignalBus.player_died.emit()


func die() -> void:
	unit_visual.visible = false
