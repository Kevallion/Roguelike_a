class_name SkillsData extends Resource


enum Skill_type {DAMAGE, HEAL, BUFF}

@export_category("information")
@export var skill_name : String = "basic attack"
@export_multiline var description : String = ""
@export var icon : Texture2D

@export_category("Cost")
@export var mana_cost : int = 0
@export var stamina_cost : int = 0
@export var move_range_cost : int = 0

@export_category("Combat Stat")
@export var min_range : int = 1
@export var max_range : int = 1
@export var amount := 2
@export var type : Skill_type
@export var target_self: bool = false
