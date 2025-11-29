class_name EnemySpawner
extends Node

signal wave_complete

@export var enemy_packed_scene: PackedScene

var enemy_array: Array[String] = ["Enemy 1", "Enemy 2"]
var current_data_index: int = 0

const SPAWN_DELAY: float = 1
const ENEMY_GROUP: String = "ENEMY_GROUP"



func _ready() -> void:
	pass # set up signals/ groups


func spawn_enemy() -> void:
	pass


func _on_enemy_timer_timeout() -> void:
	spawn_enemy()
	current_data_index += 1 # Replace with function body.
