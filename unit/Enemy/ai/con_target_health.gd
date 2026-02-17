class_name ConTargetHealth extends AiConsideration

func evaluate(actor: Unit, target_unit: Unit) -> float:
	if not is_instance_valid(actor) or not is_instance_valid(target_unit):
		return 0.0
	
	var max_health := float(target_unit.stat_component._stats.max_health)
	var current_health := float(target_unit.stat_component.current_health)
	var normalised_value : float = current_health / max_health
	
	if max_health <= 0: 
		return 0.0
		
	return compute_score(normalised_value)
