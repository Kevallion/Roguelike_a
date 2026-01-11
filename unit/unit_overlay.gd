##afficher simplement les tuiles sur lesquels je peu marcher
class_name Unit_Overlay extends TileMapLayer

func draw(cells: Array) -> void:
	clear()
	for cell in cells:
		set_cell(cell,0,Vector2i.ZERO)
