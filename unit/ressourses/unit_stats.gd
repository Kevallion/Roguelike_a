# Fichier: unit_stats.gd
# Rôle: Définit une `Resource` personnalisée pour stocker les archétypes de statistiques.
#
# L'utilisation d'une `Resource` (plutôt que de simples variables) permet de créer des "assets"
# de statistiques directement dans l'inspecteur de Godot (ex: `rat_stats.tres`, `knight_stats.tres`).
# Cela rend la création et la modification des différents types d'unités très modulaires.
#
# Ce script convertit des "points de stats" (de 0 à 4) en valeurs réelles (PV, attaque, etc.)
# via la fonction `calculate_stat`, permettant un système de progression simple.
class_name Unit_Stats extends Resource

@export var entity_name := ""

@export_group("Unit Stat Point")
@export_range(0,10,1) var point_health := 0 : set = set_point_health
@export_range(0,10,1) var point_defense := 0 : set = set_point_defense
@export_range(0,10,1) var point_attack := 0 : set = set_point_attack
@export_range(0,10,1) var point_magical_attack := 0 : set = set_point_magical_attack
@export_range(0,10,1) var point_move_range := 0 : set = set_point_move_range
@export_range(0,10,1) var point_stamina := 0 : set = set_point_stamina
@export_range(0,10,1) var point_mana := 0 : set = set_point_mana

var max_health := 0
var defense := 0
var attack := 0
var magical_attack := 0
var move_range := 0
var stamina := 0
var mana := 0

##fonction à appeler dans un ready de l'unité qui à la stat
func init_stats() -> void:
	set_point_health(point_health)
	set_point_attack(point_attack)
	set_point_move_range(point_move_range)
	set_point_magical_attack(point_magical_attack)
	set_point_stamina(point_stamina)
	set_point_mana(point_mana)
	set_point_defense(point_defense)
	
func set_point_health(new_value) -> void:
	point_health = new_value
	var base := 10
	var palier := 10
	max_health = calculate_stat(point_health,base, palier)


func set_point_attack(new_value) -> void:
	point_attack = new_value
	var base := 1
	var palier := 2
	attack = calculate_stat(point_attack,base, palier)

func set_point_stamina(new_value) -> void:
	point_stamina = new_value
	var base := 1
	var palier := 2
	stamina = calculate_stat(point_stamina,base, palier)

func set_point_mana(new_value) -> void:
	point_mana = new_value
	var base := 1
	var palier := 2
	mana = calculate_stat(point_mana,base, palier)

func set_point_magical_attack(new_value) -> void:
	point_magical_attack = new_value
	var base := 1
	var palier := 2
	magical_attack = calculate_stat(point_magical_attack,base, palier)

func set_point_defense(new_value) -> void:
	point_defense = new_value
	var base := 1
	var palier := 2
	defense = calculate_stat(point_defense,base, palier)

func set_point_move_range(new_value) -> void:
	point_move_range = new_value
	var base := 0
	var palier := 1
	move_range = calculate_stat(point_move_range,base, palier)



func calculate_stat(point_stat: int, base: int, palier: int) -> int:
	if point_stat == 0:
		return 0
	return base + ( point_stat * palier)
