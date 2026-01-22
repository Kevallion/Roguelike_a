##Une unité sait comment se déplacer*
##Sait tous ce qu'on player ou enemis peu faire
class_name Unit extends Node2D

##signal pour savoir quand l'entité à terminé son déplacement sur la grille
signal walk_finished



##variable pour savoir s'il est en train de faire une action
var is_onAction = false


@export var grid: Grid = preload("res://Utils/Grid.tres")
##réfence à l'objet responsable des stats
@onready var stat_component : StatsComponent = $"StatsComponent"
@onready var unit_visual: Unit_visual = %UnitVisual
@export var skills : Array[SkillsData] = []

@export var move_speed := 200
var move_range: int : 
	get : return stat_component.get_move_range()
	
##proprité qui reprensente la coordoonée de l'entité sur notre grille
var cell := Vector2.ZERO  : set = set_cell
func set_cell(new_value) -> void:
	cell = grid.clamp(new_value)
	


var is_walking := false : set = set_is_walking
func set_is_walking(new_value) -> void:
	is_walking = new_value 
	#on active la process pour faire le déplacement
	set_process(is_walking)

func _ready() -> void:
	
	if Engine.is_editor_hint():
		return

	#on récupère la coordonnée d'ou est sensé être placé notre entité puis on le replace bien après
	cell = grid.calculate_grid_coordinate(position)
	position = grid.calculate_map_position(cell)
	

##fonction qui prend en paramètre le chemin à suivre par l'entité.
func walk_along(path: PackedVector2Array) -> void:
	if path.is_empty():
		return 
	
	is_walking = true
	
	# On parcourt chaque point du chemin (sauf le premier qui est notre position actuelle)
	for i in range(1,path.size()):
		var target_cell := path[i]
		var cell_before := path[i-1]
		var target_wold_pos := grid.calculate_map_position(target_cell)
		var target_direction := cell_before.direction_to(target_cell)
		
		# TEMPS DU SAUT (plus c'est petit, plus il va vite)
		var step_duration := 0.20
		
		# 1. On lance l'animation de saut (Le visuel gère le Y)
		if unit_visual != null:
			unit_visual.face_direction(target_direction)
			unit_visual.play_jump_animation(step_duration)
			
			
		# 2. On déplace l'unité vers la case (L'unité gère le X et Y global)
		var tween := create_tween()
		tween.tween_property(self,"global_position",target_wold_pos,step_duration)
		# 3. On attend que ce pas soit fini avant de passer au suivant
		await tween.finished
		
		# Mise à jour logique de la cellule
		cell = target_cell
	
	is_walking = false
	walk_finished.emit()

#s'il peu agir retourne true
func can_act() -> bool:
	return is_onAction

func die() -> void:
	pass

## fonction qui renvoie true ou false si l'unité peu utiliser un skill
func can_afford_skill(skill: SkillsData) -> bool:
	if stat_component == null:
		return false
		
	if stat_component._stats.move_range < skill.move_range_cost:
		return false
	if stat_component._stats.mana < skill.mana_cost:
		return false
	if stat_component._stats.stamina < skill.stamina_cost:
		return false
		
	return true

func pay_cost_skill(skill: SkillsData) -> void:
	if stat_component == null:
		return
	
	stat_component._stats.move_range -= skill.move_range_cost
	stat_component._stats.mana -= skill.mana_cost
	stat_component._stats.stamina -= skill.stamina_cost
	
