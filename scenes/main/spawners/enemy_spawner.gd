class_name EnemySpawner
extends Node

signal wave_complete

enum Type {BASIC, WATER, WIND, FIRE}

@export var enemy_packed_scene: PackedScene
@export var start_pos: Marker2D
@onready var timer: Timer = $Timer
@onready var main: Main = get_parent()

var enemy_array: Array[Type]
var enemy_count: int = 0
var current_data_index: int = 0

const DEFAULT_SPAWN_DELAY: float = 1
const ENEMY_GROUP: String = "ENEMY_GROUP"

func _ready() -> void:
	wave_complete.connect(main._enter_build_round)


func initialize_enemies(a: Array[int]) -> void:
	self.enemy_array = a as Array[Type]
	print("this is inside of enemy_spawner", enemy_array, " ", a)


func spawn_enemy() -> void:
	timer.stop()
	if current_data_index < enemy_array.size():
		
		var enemy := enemy_packed_scene.instantiate()
		enemy._path_array.duplicate()
		enemy.position = start_pos.position
		
		get_parent().add_child(enemy)
		print("print this is enemy", current_data_index)
		
		timer.start()


func _count_deaths() -> void:
	enemy_count += 1
	if enemy_count >= enemy_array.size():
		wave_complete.emit()
		current_data_index = 0
		enemy_count = 0


func _on_enemy_timer_timeout() -> void:
	current_data_index += 1
	spawn_enemy()
	 # Replace with function body.
