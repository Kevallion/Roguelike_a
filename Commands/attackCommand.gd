# Fichier: attackCommand.gd
# Rôle: Encapsule une action d'attaque.
# Gère l'interaction entre un attaquant et un défenseur, calcule les dégâts
# (potentiellement modifiés par une compétence) et joue l'animation d'attaque.
class_name AttackCommand extends Command

var attacker : Unit
var defender : Unit
var skill : SkillsData

func _init(_attacker: Unit, _defender: Unit, _skill : SkillsData = null) -> void:
		attacker = _attacker
		defender = _defender
		if _skill != null:
			skill = _skill
		
func execute() -> void:
	attacker.is_onAction = true
	var bonus_amount = skill.amount if skill else 0
	var damage := attacker.stat_component.get_power_attack(bonus_amount)
	
	if defender == null:
		await attacker.get_tree().process_frame
		_on_finished()
	else:
	
		await attacker.unit_visual.play_attack_animation(defender.global_position)
		
		defender.stat_component.take_damage(damage)
		
		# On attend la prochaine image avant de signaler la fin
		# Cela laisse le temps au GameBoard de se mettre en position "await"
		await attacker.get_tree().process_frame
		_on_finished()

func _on_finished() -> void:
	attacker.is_onAction = false
	finished.emit()
