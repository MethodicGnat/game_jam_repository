extends VBoxContainer

@onready var game_scene: String = "res://scenes/main/gameplay.tscn"
@onready var credits_menu: Control = $"../CreditsMenu"
@onready var title: Label = $"../Title"
@onready var return_bttn: Button = $"../CreditsMenu/Return"
@onready var play_bttn: Button = $Play

func _ready() -> void:
	play_bttn.grab_focus()


func toggle_vision() -> void:
	credits_menu.visible = !credits_menu.visible
	title.visible = !title.visible
	visible = !visible


func _on_play_button_up() -> void:
	get_tree().change_scene_to_file(game_scene) # Replace with function body.


func _on_credits_button_up() -> void:
	toggle_vision()
	return_bttn.grab_focus()


func _on_quit_button_up() -> void:
	get_tree().quit() # Replace with function body.


func _on_volume_value_changed(value: float) -> void:
	pass # Replace with function body.


func _on_volume_changed() -> void:
	pass # Replace with function body.
