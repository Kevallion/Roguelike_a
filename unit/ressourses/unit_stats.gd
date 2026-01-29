class_name Unit_Stats extends Resource

@export var entity_name := ""

@export_group("Unit Stat Point")
@export_range(0,4,1) var point_health := 0 : set = set_point_health
@export_range(0,4,1) var point_defense := 0 
@export_range(0,4,1) var point_attack := 0 : set = set_point_attack
@export_range(0,4,1) var point_magical_attack := 0
@export_range(0,4,1) var point_move_range := 0 : set = set_point_move_range
@export_range(0,4,1) var point_stamina := 0
@export_range(0,4,1) var point_mana := 0

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

func set_point_move_range(new_value) -> void:
	point_move_range = new_value
	var base := 1
	var palier := 1
	move_range = calculate_stat(point_move_range,base, palier)

func calculate_stat(point_stat: int, base: int, palier: int) -> int:
	return base + ( point_stat * palier)
