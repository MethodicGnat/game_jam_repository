extends Control

@onready var menu_scene: String = "res://scenes/main_menu/main_menu.tscn"

func _on_restart_button_up() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene() # Replace with function body.


func _on_return_button_up() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(menu_scene) # Replace with function body.
