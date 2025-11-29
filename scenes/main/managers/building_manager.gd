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
	tower.position = tile_map_layer.map_to_local(cell_pos)
	
	tower.add_to_group(TOWER_GROUP)
	used_tiles.append(cell_pos)


func remove_tower(cell_pos: Vector2i) -> void:
	for i in get_tree().get_nodes_in_group(TOWER_GROUP):
		if Vector2i(i.position) == cell_pos * 64:
			i.queue_free()
			used_tiles.erase(Vector2i(i.position)/64)


func is_valid_tower_placement(cell_pos: Vector2i) -> bool:
	if used_tiles.has(cell_pos):
		return false
	
	var cell_data = tile_map_layer.get_cell_tile_data(cell_pos).get_custom_data(IS_BUILDABLE)
		
	return cell_data
