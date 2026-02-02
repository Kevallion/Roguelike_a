class_name AiConsideration extends Resource

## C'est ici que tu dessineras ta courbe dans l'éditeur (le "Traducteur") 
@export var response_curve: Curve

## C'est la question que l'Expert pose.
## Par défaut, elle renvoie 0. Les scripts enfants (comme Santé) vont changer ça.
func evaluate(actor: Unit, target_unit: Unit) -> float:
	return 0.0

## C'est l'outil mathématique.
## Il prend la réponse brute (ex: 50% vie) et regarde sur la courbe ce que ça donne en "Envie" (ex: 0% envie).
func compute_score(normalized_value: float) -> float:
	var clamped_value : float = clampf(normalized_value,0.0,1.0)
	
	if response_curve:
		return response_curve.sample(clamped_value)
	
	return clamped_value
