# Fichier: stats_components.gd
# Rôle: Composant dédié à la gestion de toutes les statistiques d'une unité.
# C'est un exemple d'Architecture Orientée Composants (Component-Based Architecture).
# La logique des statistiques est isolée ici, au lieu d'être mélangée dans la classe `Unit`.
#
# Responsabilités:
# - Contient les statistiques de base via la ressource `_stats` (Unit_Stats).
# - Suit les valeurs actuelles (vie, mana, endurance, etc.).
# - Applique les dégâts (`take_damage`) et les soins (`take_heal`).
# - Gère les "buffs": applique les modifications de stats temporaires et suit leur durée,
#   en les retirant automatiquement à la fin du bon nombre de tours (`on_turn_start`).
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
signal stat_buffed(stat_affect: SkillsData.Stat_affect, turn_duration: int)

var active_buffs := []

@onready var unit : Unit = $".."
var current_health : int : set = set_current_health
var current_stamina : int
var current_mana : int
var current_move_range: int


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
		current_move_range = _stats.move_range
		current_mana = _stats.mana
		
func get_move_range() -> int:
	return _stats.move_range

func is_heath_critical() -> bool:
	var ratio = float(current_health) / float(_stats.max_health) 
	var critical_ratio := 0.3
	return ratio <= critical_ratio

func get_power_attack(bonus_damage: int = 0) -> int:
	return _stats.attack + bonus_damage

##function qui calcule les dégat réçu par le joueur
func take_damage(amount: int) -> void:
	var final_damage : int = max(1,amount - _stats.defense)
	print(_stats.entity_name, " has lost ", final_damage, "PV")
	Globals.signalBus.TakedDamage.emit(final_damage, owner.global_position)
	
	self.current_health -= final_damage 
	
	print(_stats.entity_name, " has now ", current_health, "PV")
	
func take_heal(amount: int) -> void:
	self.current_health += amount

##fonction qui applique un buff temporaire à la stat	
func buff_stat(stat_affect: SkillsData.Stat_affect, amount: int, turn_duration: int ) -> void:
	
	match stat_affect:
		SkillsData.Stat_affect.ATTACK:
			_stats.attack += amount
		SkillsData.Stat_affect.DEFENSE:
			_stats.defense += amount
		SkillsData.Stat_affect.MAGICAL_ATTACK:
			_stats.magical_attack += amount
		SkillsData.Stat_affect.MOVE_RANGE:
			_stats.move_range += amount
		SkillsData.Stat_affect.MANA:
			_stats.mana += amount
		SkillsData.Stat_affect.STAMINA:
			print("un buff à été appliqué de stamina")
			current_stamina += amount
			print(current_stamina)
		SkillsData.Stat_affect.HEALTH:
			current_health += amount
	
	if turn_duration != 0:
		active_buffs.append(
					{ "stat": stat_affect, 
					"amount": amount, 
					"turn_duration" : turn_duration}
					)
			
	stat_buffed.emit(stat_affect, turn_duration)

func on_turn_start() -> void:
	
	
	##parcourir la liste des buff quon à en mémoire
	for i in range(active_buffs.size(),0, -1) :
		var buff =  active_buffs[i-1]
		if buff.turn_duration > 0:
			buff.turn_duration -= 1
			
		elif buff.turn_duration == 0:
			match buff.stat:
				SkillsData.Stat_affect.ATTACK:
					_stats.attack -= buff.amount
				SkillsData.Stat_affect.DEFENSE:
					_stats.defense -= buff.amount
				SkillsData.Stat_affect.MAGICAL_ATTACK:
					_stats.magical_attack -= buff.amount
				SkillsData.Stat_affect.MOVE_RANGE:
					_stats.move_range -= buff.amount
				SkillsData.Stat_affect.MANA:
					_stats.mana -= buff.amount
				SkillsData.Stat_affect.STAMINA:
					current_stamina -= buff.amount
				SkillsData.Stat_affect.HEALTH:
					current_health -= buff.amount
			
			active_buffs.erase(buff)
			
	current_move_range = _stats.move_range	
