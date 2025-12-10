extends TileMapLayer
class_name NavigationTileMapLayer

@export var source_id : int
@export var nav_cell_coords : Vector2i
@export var obstacle_cell_coords : Vector2i

func close_nav_cell(coords : Vector2i):
	set_cell(coords, source_id, obstacle_cell_coords)
	
func set_nav_cell(coords : Vector2i):
	set_cell(coords, source_id, nav_cell_coords)
	
