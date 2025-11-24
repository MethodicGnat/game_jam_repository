class_name Main
extends Node2D

@export var tower_packed_scene: PackedScene
@export var building_manager: BuildingManager
@onready var tile_map_layer: TileMapLayer = $TileMapLayer


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		var cell_pos: Vector2i = tile_map_layer.local_to_map(tile_map_layer.get_local_mouse_position())
		
		building_manager.place_tower(cell_pos, tower_packed_scene)
