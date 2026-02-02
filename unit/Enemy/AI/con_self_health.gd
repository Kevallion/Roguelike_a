class_name Con_SelfHealth extends AI_Consideration

func score(context: Dictionary) -> float:
	var unit: Unit = context.get("unit")

	if not unit or not unit.stat_component:
		return 0.0

	var current = float(unit.stat_component.current_health)
	var max_hp = float(unit.stat_component._stats.max_health)

	if max_hp <= 0: return 0.0

	return clamp(current / max_hp, 0.0, 1.0)
