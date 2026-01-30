# Fichier: healCommand.gd
# Rôle: Encapsule une action de soin.
# Applique un montant de soin à une unité "receiver" (receveur),
# en provenance d'un "launcher" (lanceur), basé sur les propriétés d'une compétence.
class_name HealCommand extends Command

var receiver : Unit
var launcher : Unit
var skill : SkillsData

func _init(_launcher: Unit, _receiver: Unit, _skill: SkillsData) -> void:
	launcher = _launcher
	receiver = _receiver
	skill = _skill
	
func execute() -> void:
	launcher.is_onAction = true
	if receiver == null:
		_on_finished()
		return
		
	receiver.stat_component.take_heal(skill.amount)
	
	# On attend la prochaine image avant de signaler la fin
	# Cela laisse le temps au GameBoard de se mettre en position "await"
	await receiver.get_tree().process_frame
	_on_finished()

func _on_finished() -> void:
	launcher.is_onAction = false
	finished.emit()
