class_name Con_DistanceToTarget extends AI_Consideration

func score(context: Dictionary) -> float:
	var unit: Unit = context.get("unit")
	var target: Unit = context.get("target")
	var board: GameBoard = context.get("board")

	if not unit or not target or not board:
		return 0.0

	var distance = board.grid.get_manathan_distance(unit.cell, target.cell)
	var max_dist = 10.0 # Valeur arbitraire pour la normalisation, à ajuster ou exporter

	return clamp(float(distance) / max_dist, 0.0, 1.0)
