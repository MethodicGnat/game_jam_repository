class_name BuildingManager
extends Node

@export var tile_map_layer: TileMapLayer

const TOWER_GROUP: String = "TOWER_GROUP"
const IS_BUILDABLE: String = "buildable"

var used_tiles: Array[Vector2i] = []

func place_tower(cell_pos: Vector2i, tower_packed_scene: PackedScene) -> void:
	if !is_valid_tower_placement(cell_pos):
		return
	
	var tower = tower_packed_scene.instantiate()
	add_child(tower)
	tower.position = cell_pos * 64
	
	tower.add_to_group(TOWER_GROUP)
	used_tiles.append(cell_pos)
	
func is_valid_tower_placement(cell_pos: Vector2i) -> bool:
	if used_tiles.has(cell_pos):
		return false
	
	var cell_data = tile_map_layer.get_cell_tile_data(cell_pos).get_custom_data(IS_BUILDABLE)
		
	return cell_data
