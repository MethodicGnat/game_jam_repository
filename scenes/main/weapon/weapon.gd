class_name Weapon
extends Node2D

const WEAPONS_GROUP: String = "WEAPONS_GROUP"

var damage
var speed

func _ready() -> void:
	add_to_group(WEAPONS_GROUP)
