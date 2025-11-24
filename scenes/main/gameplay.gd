class_name Main
extends Node2D

@export var tower_packed_scene: PackedScene
@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var highlight_tile: HighlightTile = $HighlightTile

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		var cell_pos: Vector2i = tile_map_layer.local_to_map(tile_map_layer.get_local_mouse_position())
		var cell_data = tile_map_layer.get_cell_tile_data(cell_pos).get_custom_data("buildable")
		
		print_debug(cell_data)
