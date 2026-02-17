class_name Cursor extends Node2D

##Emited quand un clique  est fait sur une célule ou quand le joueur appui sur ui accep
signal accept_pressed(cell: Vector2)

##Emited quand le cursor survol une nouvelle célule
signal moved(new_cell: Vector2)

@export var grid : Grid = preload("res://Utils/Grid.tres")

var cell := Vector2.ZERO : set = set_cell

func set_cell(new_value) -> void:
	var new_cell = grid.clamp(new_value)
	if new_cell.is_equal_approx(cell):
		return
	cell = new_cell
	global_position = grid.calculate_map_position(cell)
	moved.emit(cell)

	
	
func _ready() -> void:
	global_position = grid.calculate_map_position(cell)

func _unhandled_input(event: InputEvent) -> void:
	#si la souris bouge on calcule sa nouvelle position en priorité
	if event is InputEventMouseMotion:
		cell = grid.calculate_grid_coordinate(get_global_mouse_position())
		
	#si le joueur confirme une position on valid un click pour une nouvelle célule
	elif event.is_action_pressed("ui_accept") or event.is_action_pressed("right_click"):
		accept_pressed.emit(cell)
		##stoper la propagation de l'input pour pas que d'autre entité puisse prendre en compte
		#get_viewport().set_input_as_handled()
