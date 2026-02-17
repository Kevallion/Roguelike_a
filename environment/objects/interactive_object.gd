##component que l'on va utiliser pour créer nos objet
class_name InteractiveObject extends Node2D

# Si true, on ne peut pas marcher dessus (ex: Mur, Coffre). 
# Si false, on marche dessus (ex: Piège, Pièce d'or).
@export var is_blocking := false

# La distance requise : 0 = Sur la même case, 1 = Adjacente
@export var interaction_range : int = 1

var grid := preload("res://utils/Grid.tres")

##proprité qui reprensente la coordoonée de l'entité sur notre grille
var cell := Vector2.ZERO  : set = set_cell


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	#on récupère la coordonnée d'ou est sensé être placé notre entité puis on le replace bien après
	cell = grid.calculate_grid_coordinate(position)
	position = grid.calculate_map_position(cell)
	print(cell)

func set_cell(new_value) -> void:
	cell = grid.clamp(new_value)
	

func can_interact(user_cell: Vector2) -> bool:
	print("try interact")
	var distance = grid.get_manathan_distance(user_cell,cell)
	return distance <= interaction_range

func interact(unit: Unit) -> void:
	print("a interaction with ", unit.name)
