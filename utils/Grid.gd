class_name Grid extends Resource


##Propriété de la taille total de la grille en colonne et ligne. Cette propriété peu etre changé lors d'un changement de salle
@export var grid_size := Vector2(40,40)


##Propriété de la taille des cellules de la grille
@export var cell_size := Vector2(16,16) : set = set_cell_size

func set_cell_size(new_value) -> void:
	cell_size = new_value
	_half_cell_size = cell_size/2
	
##Propriété de la moitié de la taille d'une célule
var _half_cell_size := cell_size/2


##Retourne la position centré en pixel de l'emplacement de la célule
func calculate_map_position(grid_position: Vector2) -> Vector2:
	return grid_position * cell_size + _half_cell_size
	

##Retourne la coordonée de la céllule sur la grille
func calculate_grid_coordinate(map_position: Vector2) -> Vector2:
	return (map_position/ cell_size).floor()
	
##Retourne vrai si l'entité n'est pas au dela de la limite de la grille
func is_within_bounds(cell_coordinates: Vector2) -> bool:
	var out := cell_coordinates.x >= 0 and cell_coordinates.x < grid_size.x
	return  out and cell_coordinates.y >= 0 and cell_coordinates.y < grid_size.y
	
##Permet de clamp la position de l'entité
func clamp(grid_position: Vector2) -> Vector2:
	var out := grid_position
	
	out.x = clamp(out.x,0,grid_size.x - 1.0)
	out.y = clamp(out.y,0,grid_size.y - 1.0)
	return out
	
func get_manathan_distance(start_cell, end_cell) -> int:
		var difference : Vector2 = (end_cell - start_cell).abs()
		var distance = int(difference.x + difference.y)
		return distance
		
## permet de calculer un id unique
func get_unique_id(cell:Vector2) -> int:
	return int(cell.x + (cell.y * grid_size.x))

##cette fonction renvoie la cell la plus proche dans le walkable cell
func get_nearest_walkable_cell(new_cell: Vector2, walkable_cells: Array) -> Vector2:
	var nearest_cell : Vector2
	var max_distance = INF
	
	##on parcours chaque célule pour trouver la plus proche
	for cell in walkable_cells:
		var _distance = get_manathan_distance(cell, new_cell)
	
		if _distance < max_distance:
			max_distance = _distance
			nearest_cell = cell
			
	return nearest_cell

func get_farthest_walkable_cell(new_cell: Vector2, walkable_cells: Array) -> Vector2:
	var farthest_cell: Vector2
	var max_distance = 0
	
	for cell in walkable_cells:
		var distance = get_manathan_distance(new_cell,cell)
		
		if distance > max_distance:
			max_distance = distance
			farthest_cell = cell
	return farthest_cell
	
##Cette fonction permet de calculer la célule la plus proche autour autour d'un point
##par rapport à la coordonné de l'entité concerné
func get_neareast_cells_around_a_target(start_cell: Vector2, target_cell: Vector2) -> Vector2:
	var NEIGHBORS_CELLS:= [Vector2.UP, Vector2.RIGHT, Vector2.DOWN,Vector2.LEFT]
	var nearest_cell := start_cell
	var max_distance = INF

	
	#la la plus proche par rapport au joueur
	for cell in NEIGHBORS_CELLS:
		var neighbor_cell = target_cell + cell
		var _distance = get_manathan_distance(start_cell, neighbor_cell)
		if _distance < max_distance:
			max_distance = _distance
			nearest_cell = neighbor_cell
	
	return nearest_cell
