# Fichier: skills_data.gd
# Rôle: Définit une `Resource` personnalisée pour encapsuler toutes les données d'une compétence.
#
# Similairement à `Unit_Stats`, utiliser une `Resource` permet de créer chaque compétence
# comme un asset indépendant (`.tres`) dans l'inspecteur Godot (ex: `basic_attack.tres`).
#
# Chaque fichier de ressource de compétence contient toutes les informations nécessaires à son fonctionnement:
# - Informations générales (nom, description, icône).
# - Coûts (mana, endurance, etc.).
# - Propriétés de combat (portée, montant de l'effet, type, stat affectée, durée).
# - Comportement (cible soi-même ou non).
class_name SkillsData extends Resource


enum Skill_type {DAMAGE, HEAL, BUFF}
enum Stat_affect {ATTACK, DEFENSE, MAGICAL_ATTACK, MOVE_RANGE, MANA, STAMINA, HEALTH }
enum AOE_Shape {POINT, CROSS, CIRCLE, SQUARE}


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
@export_range(0.0,4.0,1.0) var turn_duration : int = 1
@export var target_self: bool = false
@export var considerations: Array[AiConsideration]

@export_category("Area of Effect")
@export var aoe_shape: AOE_Shape = AOE_Shape.POINT
@export var aoe_size : int = 0
