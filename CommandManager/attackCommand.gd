class_name AttackCommand extends Command

var attacker : Unit
var defender : Unit

func _init(_attacker: Unit, _defender: Unit) -> void:
		attacker = _attacker
		defender = _defender
		
func execute() -> void:
	var damage := attacker.stat_component.get_power_attack()
	defender.stat_component.take_damage(damage)
	
	# On attend la prochaine image avant de signaler la fin
	# Cela laisse le temps au GameBoard de se mettre en position "await"
	await attacker.get_tree().process_frame
	_on_finished()

func _on_finished() -> void:
	finished.emit()
