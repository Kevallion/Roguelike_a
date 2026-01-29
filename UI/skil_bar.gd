class_name SkillBar extends HBoxContainer




var current_seleted_skill : SkillsData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.skill_inited.connect(_on_skill_initialised)



func _on_skill_initialised(skills: Array[SkillsData]) -> void:
	for child in get_children():
		child.queue_free()
	var id := 1
	for skill in skills:
		var skill_btn : SkillButton = preload("uid://dbkrdivn3awpo").instantiate()
		add_child(skill_btn)
		skill_btn.texture_normal = skill.icon
		skill_btn.description = skill.description
		skill_btn.change_spell = skill.skill_name
		skill_btn._skill = skill
		skill_btn.change_key = str(id)
		id += 1
