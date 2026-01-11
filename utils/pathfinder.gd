##Objet qui permet d'obtenir le chemin sur une grille
class_name PathFinder extends RefCounted


#les direction quon va parcourir
const DIRECTIONS = [Vector2.LEFT,Vector2.UP,Vector2.RIGHT,Vector2.DOWN]

var _grid: Grid
var _astar = AStar2D.new()

#quand on crée notre objet on lui passe la configuration de la grille et les célule marchable
func _init(grid: Grid, walkable_cells: Array) -> void:
	_grid = grid 
	#on a besoin d'un identifiant unique alors on les sauvegard dans un dictionnaire
	var cell_mappings := {}
	for cell in walkable_cells:
		cell_mappings[cell] = _grid.get_unique_id(cell)
	
	#on ajoute et connect les points
	_add_and_connect_point(cell_mappings)

func _add_and_connect_point(cell_mapping: Dictionary) -> void:
	#parcourt le dictionnaire qui renvoie des clé et connecter les point
	for current_cell in cell_mapping:
		_astar.add_point(cell_mapping[current_cell], current_cell)
		
	#parcours pour connecter les points maitenant
	for current_cell in cell_mapping:
		for current_neightbor: Vector2 in DIRECTIONS:
			var neighbor_position = current_cell + current_neightbor
			if not cell_mapping.has(neighbor_position):
				continue
			var current_cell_index = cell_mapping[current_cell]
			var neighbor_cell_index = cell_mapping[neighbor_position]
			
			if not _astar.are_points_connected(current_cell_index,neighbor_cell_index):
				_astar.connect_points(current_cell_index,neighbor_cell_index)


##fonction qui permet d'obtenir un chemin entre la position inital et la position de fin
func find_path_to_target(start: Vector2, end: Vector2) -> PackedVector2Array:
	var start_index := _grid.get_unique_id(start)
	var end_index := _grid.get_unique_id(end)

	
	if _astar.has_point(start_index) and _astar.has_point(end_index):
		return _astar.get_point_path(start_index, end_index)
	else:
		return PackedVector2Array()
