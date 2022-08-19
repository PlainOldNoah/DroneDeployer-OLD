extends Node2D

func _ready():
	var used_cells = $TestingMap.get_used_cells_by_id(0)
	var world_cell = $TestingMap.map_to_world(used_cells[1])
	print(world_cell)
