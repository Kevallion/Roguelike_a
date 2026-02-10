class_name AI_Consideration extends Resource

@export var curve: Curve
@export_range(0.0, 1.0) var weight: float = 1.0

# Cette fonction devra être surchargée par les enfants
# Elle doit retourner une valeur brute entre 0.0 et 1.0
func score(context: Dictionary) -> float:
	return 0.0

# Calcule le score final en appliquant la courbe et le poids
func evaluate(context: Dictionary) -> float:
	var raw_score = score(context)
	var curved_score = raw_score

	if curve:
		curved_score = curve.sample(raw_score)

	return curved_score * weight
