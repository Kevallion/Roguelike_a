class_name conDistanceToTarget extends AiConsideration

@export var max_distance:= 10.0



##renvoie le score par rapport à la distance entre l'ennemie et la target
func evaluate(actor: Unit, target_unit: Unit) -> float:
	
	if not is_instance_valid(actor) or not is_instance_valid(target_unit):
		return 0.0
	var distance := actor.grid.get_manathan_distance(actor.cell,target_unit.cell)
	var normalised_value := clampf(float(distance)/max_distance, 0.0,1.0)
	
	return compute_score(normalised_value)
	
