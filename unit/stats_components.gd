##objet responsable uniquement des statistiques d’une entité.
class_name StatsComponent extends Node

#Ce qu’il DOIT gérer
#PV actuels / PV max
#Attaque, défense, portée, etc.
#Modificateurs temporaires
#Conditions simples (mort, critique, seuils)
#Exemples de questions auxquelles il répond :
#“Est-ce que je suis en vie ?”
#“Mes PV sont-ils critiques ?”
#“Combien de dégâts je fais ?”
#“Est-ce que j’ai un bonus actif ?”

@export var _stats : Unit_Stats

signal health_changed(current_hp, max_hp)
signal health_depleted(unit: Unit)

@onready var unit : Unit = $".."
var current_health : int : set = set_current_health
var current_stamina : int

func set_current_health(new_value) ->void:
	current_health = clampi(new_value,0, _stats.max_health)
	
	health_changed.emit(current_health, _stats.max_health)
	
	if current_health <= 0:
		health_depleted.emit(unit)
		
func _ready() -> void:
	if _stats:
		_stats = _stats.duplicate()
		
		_stats.init_stats()
		
		current_health = _stats.max_health
		current_stamina = _stats.stamina

func get_move_range() -> int:
	return _stats.move_range

func is_heath_critical() -> bool:
	var ratio = float(current_health) / float(_stats.max_health) 
	var critical_ratio := 0.3
	return ratio <= critical_ratio

func get_power_attack(bonus_damage: int = 0) -> int:
	return _stats.attack + bonus_damage

func take_damage(amount: int) -> void:
	var final_damage : int = max(1,amount - _stats.defense)
	print(_stats.entity_name, " has lost ", final_damage, "PV")
	self.current_health -= final_damage 
	print(_stats.entity_name, " has now ", current_health, "PV")
	
func take_heal(amount: int) -> void:
	self.current_health += amount
