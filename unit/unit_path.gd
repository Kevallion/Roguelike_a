##objet q'ui du coup va nous renvoyer le chemin pour notre entité
class_name Unit_Path extends TileMapLayer

#on connect notre grid
@export var grid : Grid

#on met une référence du pathFinder
var _pathFinder : PathFinder

## variable qui garde en mémoire le chemin trouvé par pathfinder
var current_path := PackedVector2Array()

##fonction appeler à chaque fois qu'une entité veut un chemin
func initalize(walkable_cells: Array) -> void:
	_pathFinder = PathFinder.new(grid,walkable_cells)

##function qu'on va appeler pour dessiner le chemin si nécessaire
func draw_path(cell_start: Vector2, cell_end: Vector2, move_points: int) -> void:
	#effacer les tiles
	clear()
	
	#obtenir le chemin de tracer
	if _pathFinder == null:
		return
	
	var full_path = _pathFinder.find_path_to_target(cell_start,cell_end)
	current_path = limited_path(full_path,move_points)

	#on parcourt le tableau de chemin pour placer les célule du chemin sur la tilemap
	for cell in current_path:
		set_cell(cell,0,Vector2i.ZERO)

##cette fonction permert de construire le chemin
func build_path(cell_start: Vector2, cell_end: Vector2, move_points: int) -> PackedVector2Array:
	#obtenir le chemin de tracer
	if _pathFinder == null:
		return []

	var full_path = _pathFinder.find_path_to_target(cell_start,cell_end)

	current_path = limited_path(full_path,move_points)
	
	return current_path
	
##fonction pour limiter le chemin si ça dépasse le nombre de case prévue
func limited_path(path: PackedVector2Array, max_range: int) -> PackedVector2Array:
	var new_path := PackedVector2Array()
	#+1 car la premiere case c'est la position actuelle
	var step = min(path.size(),max_range + 1)
	
	#on parcour de 0 à la max_range
	for i in range(step):
		#et ajoute les point du chemin dans un nouveau chemin
		new_path.append(path[i])
		
	return new_path
	
##function pour arreter de dessiner un chemin
func stop() -> void:
	_pathFinder = null
	clear()
