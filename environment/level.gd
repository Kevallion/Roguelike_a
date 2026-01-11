##Cette objet va se charger de connaitre le terrain et pouvoir dire s'il est possible de se déplacer
class_name Level extends Node2D

#les direction quon va parcourir
const DIRECTIONS = [Vector2.LEFT,Vector2.UP,Vector2.RIGHT,Vector2.DOWN]

#réference de ma grille
@export var _grid: Grid 

#tilemap pour les colision
@onready var tile_map_walls: TileMapLayer = %TileMap_Walls


##fonction pour obtenir les célule sur lesquel l'unité peu marcher
func get_walkable_cells(unit: Unit, units: Dictionary) -> Array:
	return get_reachble_cells_around(unit.cell, unit.move_range, units)
	
##cette fonction va permettre d'obtenir les célule attégnable autour de l'unité
func get_reachble_cells_around(cell: Vector2, max_distance: int, units: Dictionary) ->Array:
	#l'array des célules sur lesquelles je pourrai marcher en sortie
	var array := []
	
	#on stock la premiere position de l'unité
	var stack :=[cell]
	
	#on fait fait une boucle while jusqu'a ce que notre stack soit vide
	while not stack.is_empty():
		#on récupère la derniere position dans le stack
		var current = stack.pop_back()
		
		#si la coordonné est déja dans notre array on passe à la suivante ou pas marchable
		if current in array:
			continue
		if not is_cell_walkable(current):
			continue
			
		#on verifie que la célule n'est pas plus que ce que peu marcher notre unité
		#on calcule la distance à la manatan depuis la grille
		var distance := _grid.get_manathan_distance(cell,current)
		if distance > max_distance:
			continue
		
		#si tout est bon on l'ajoute
		array.append(current)
		
		#on parcours chaque voisin afin de savoir on doit l'ajouter
		for direction in DIRECTIONS:
			var cell_neighboor = current + direction
			#s'il est occupé on l'ajoute pas
			if is_occupied(cell_neighboor,units):
				continue
			if cell_neighboor in array:
				continue
			
			stack.append(cell_neighboor)
	return array

##renvoie si une unité est déja sur une célule spécifique
func is_occupied(cell: Vector2, units: Dictionary) -> bool:
	return units.has(cell)

##fonction pour savoir si la cell ou on veut aller est marchable
func is_cell_walkable(cell: Vector2) -> bool:
	if not _grid.is_within_bounds(cell):
			return false
	if tile_map_walls.get_cell_source_id(cell) != -1:
			return false
	return true
