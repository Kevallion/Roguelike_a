# Fichier: buffCommand.gd
# Rôle: Encapsule l'application d'un "buff" (amélioration de statistique).
# Modifie une statistique d'une unité pour une durée déterminée ou permanente,
# en se basant sur les informations de la compétence utilisée.
class_name BuffCommand extends Command

var receiver : Unit
var launcher : Unit
var skill : SkillsData


func _init(_launcher: Unit, _receiver: Unit, _skill: SkillsData) -> void:
	self.receiver = _receiver
	self.launcher = _launcher
	self.skill = _skill

func execute() -> void:
	launcher.is_onAction = true
	if receiver == null:
		_on_finished()
		return
	
	receiver.stat_component.buff_stat(skill.affect, skill.amount,skill.turn_duration)
	
	# On attend la prochaine image avant de signaler la fin
	# Cela laisse le temps au GameBoard de se mettre en position "await"
	await receiver.get_tree().process_frame
	_on_finished()
	


func _on_finished() -> void:
	launcher.is_onAction = false
	finished.emit()
