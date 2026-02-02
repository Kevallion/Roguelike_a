class_name ConSelfHealth  extends AiConsideration

func evaluate(actor: Unit, target_unit: Unit) -> float:
	var max_health = actor.stat_component._stats.max_health
	var current_health = actor.stat_component.current_health
	var normalised_value : float = float(current_health) / float(max_health)
	return  compute_score( normalised_value)
	
	
	
