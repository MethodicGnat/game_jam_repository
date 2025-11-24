class_name HighlightTile
extends Node2D


func followMousePos() -> void:
	var mouse_pos: Vector2i =  get_global_mouse_position() / 64
	
	mouse_pos *= 64
	position = mouse_pos
	
func _process(_delta: float) -> void:
	followMousePos()
	
