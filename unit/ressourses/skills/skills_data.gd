class_name SkillsData extends Resource


enum Skill_type {DAMAGE, HEAL, BUFF}
enum Stat_affect {ATTACK, DEFENSE, MAGICAL_ATTACK, MOVE_RANGE, MANA, STAMINA, HEALTH }

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
@export var affect : Stat_affect
@export_range(1.0,4.0,1.0) var turn_duration := 1.0
@export var target_self: bool = false
