class_name EnemySpawner
extends Node

signal wave_complete
signal new_score(score: int)

enum Type {BASIC, WATER, WIND, FIRE}

@export var enemy_packed_scene: PackedScene
@export var start_pos: Marker2D
@onready var timer: Timer = $Timer
@onready var main: Main = get_parent()
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"

var enemy_array: Array[Type]
var enemy_count: int = 0
var current_data_index: int = 0

const DEFAULT_SPAWN_DELAY: float = 1
const ENEMY_GROUP: String = "ENEMY_GROUP"

func _ready() -> void:
	wave_complete.connect(main._enter_build_round)
	new_score.connect(main._on_new_score)


func initialize_enemies(a: Array[int]) -> void:
	self.enemy_array = a as Array[Type]


func spawn_enemy() -> void:
	timer.stop()
	if current_data_index < enemy_array.size():
		
		var enemy := enemy_packed_scene.instantiate()
		enemy.name = "Enemy"
		enemy._path_array.duplicate()
		enemy.position = start_pos.position
		
		get_parent().add_child(enemy)
		
		timer.start()


func _count_deaths(is_dead_to_turret: bool) -> void:
	if is_dead_to_turret:
		enemy_count += 1
		if enemy_count >= enemy_array.size():
			wave_complete.emit()
			new_score.emit(enemy_count)
			current_data_index = 0
			enemy_count = 0
	else:
		animation_player.play("game_over")
		get_tree().paused = true


func _on_enemy_timer_timeout() -> void:
	current_data_index += 1
	spawn_enemy()
	 # Replace with function body.
