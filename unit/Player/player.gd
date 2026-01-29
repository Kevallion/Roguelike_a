##Objet qui réprésente la logique du joueur
class_name Player extends Unit


func _ready() -> void:
	super._ready()
	stat_component.health_depleted.connect(_on_health_depleted)
	SignalBus.skill_inited.emit(skills)
	
func _on_health_depleted(unit: Unit) -> void:
	SignalBus.player_died.emit()


func die() -> void:
	unit_visual.visible = false
