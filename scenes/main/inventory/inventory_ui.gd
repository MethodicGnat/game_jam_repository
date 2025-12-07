extends Control

@onready var inventory: Inventory = preload("res://scenes/main/inventory/inventory.tres")
@onready var slots: Array = $HBoxContainer.get_children()

func _ready() -> void:
	update_slots()


func update_slots() -> void:
	print(inventory.items.size())
	for i in range(min(inventory.items.size(), slots.size())):
		slots[i].update(inventory.items[i])
