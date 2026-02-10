class_name Con_TargetHealth extends AI_Consideration

func score(context: Dictionary) -> float:
	var target: Unit = context.get("target")

	if not target or not target.stat_component:
		return 0.0

	var current = float(target.stat_component.current_health)
	var max_hp = float(target.stat_component._stats.max_health)

	if max_hp <= 0: return 0.0

	return clamp(current / max_hp, 0.0, 1.0)
