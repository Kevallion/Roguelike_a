##Une unité sait comment se déplacer*
##Sait tous ce qu'on player ou enemis peu faire
class_name Unit extends Path2D

##signal pour savoir quand l'entité à terminé son déplacement sur la grille
signal walk_finished
@onready var path_follow_2d: PathFollow2D = %PathFollow2D
@onready var unit_visual: Unit_visual = %UnitVisual

##variable pour savoir s'il est en train de faire une action
var is_onAction = false


@export var grid: Grid = preload("res://Utils/Grid.tres")
##réfence à l'objet responsable des stats
@onready var stat_component : StatsComponent = $"StatsComponent"

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
	
	
	curve = Curve2D.new()
	
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
		
	path_follow_2d.progress += move_speed * delta
	
	if path_follow_2d.progress_ratio >= 1.0 or ( curve.point_count == 1 and is_walking == true):
		print("fin du chemin")
		is_walking = false
		var fina_cell := grid.calculate_grid_coordinate(path_follow_2d.global_position)
		position = grid.calculate_map_position(fina_cell)
		cell = grid.calculate_grid_coordinate(position)
		path_follow_2d.progress_ratio = 0.0
		curve.clear_points()
		is_onAction = false
		walk_finished.emit()

##fonction qui prend en paramètre le chemin à suivre par l'entité.
func walk_along(path: PackedVector2Array) -> float:
	var time := 0.0
	if path.is_empty():
		return time
	print("le path", path)
	curve.clear_points()
	curve.add_point(path_follow_2d.position)
	for index in range(1, path.size()):
		var point = path[index]
		##ici on fait to_local parce que path contient des coordonné monde. Et curve est enfant de notre Node
		var local_pos = to_local(grid.calculate_map_position(point))
		curve.add_point(local_pos)
	print("temp du chemin ", time)
	print(curve.point_count)
	#cell = path[-1]
	#on met que notre entité marche
	is_walking = true
	
	return time
#s'il peu agir retourne true
func can_act() -> bool:
	return is_onAction

func die() -> void:
	pass
