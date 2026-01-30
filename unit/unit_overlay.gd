##afficher simplement les tuiles sur lesquels je peu marcher
class_name Unit_Overlay extends Node2D

@onready var move_layer : TileMapLayer = %MoveLayer
@onready var attack_layer : TileMapLayer = %AttackLayer
@onready var impact_layer : TileMapLayer = %ImpactLayer


##dessiner les case marchable
func draw(cells: Array) -> void:
	move_layer.clear()
	for cell in cells:
		move_layer.set_cell(cell,0,Vector2i.ZERO)

##dessiner les case attaquable
func draw_range(cells: Array) -> void:
	attack_layer.clear()
	for cell in cells:
		attack_layer.set_cell(cell,0,Vector2i.ZERO)

##dessiner l'impact de l'attaque
func draw_impact(cells: Array) -> void:
	impact_layer.clear()
	for cell in cells:
		impact_layer.set_cell(cell,0,Vector2i.ZERO)


func clear() -> void:
	move_layer.clear()
	attack_layer.clear()
	impact_layer.clear(	)

func clear_impact() -> void:
	impact_layer.clear()

func clear_attack() -> void:
	attack_layer.clear()

func clear_move() -> void:
	move_layer.clear()