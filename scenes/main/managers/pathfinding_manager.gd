class_name PathfindingManager
extends Node

@export var tile_map_grid: TileMapLayer

var astar_grid: AStarGrid2D = AStarGrid2D.new()
var path_array: Array[Vector2i] = []

func _ready() -> void:
	prepare_astar_grid()
	

func prepare_astar_grid() -> void:
	astar_grid.region = tile_map_grid.get_used_rect()
	astar_grid.cell_size = tile_map_grid.tile_set.tile_size
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	
	astar_grid.update()
	
	update_terrain_movement_values()


func get_valid_path(start_pos: Vector2i, end_pos: Vector2i) -> Array[Vector2i]:
	path_array.clear()
	
	for point in astar_grid.get_point_path(start_pos, end_pos):
		var current_point: Vector2i = point
		
		current_point += astar_grid.cell_size / 2 as Vector2i
		path_array.append(current_point)
		
	return path_array


func update_terrain_movement_values() -> void:
	for i in tile_map_grid.get_used_cells():
		var tile_movement_cost = tile_map_grid.get_cell_tile_data(i).get_custom_data("movement_cost")
		if tile_movement_cost <= 10:
			astar_grid.set_point_weight_scale(i, tile_movement_cost)
		else:
			astar_grid.set_point_solid(i, true)
			
