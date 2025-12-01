class_name Main
extends Node2D

@export var tower_packed_scene: PackedScene
@export var building_manager: BuildingManager
@export var enemy_spawner: EnemySpawner
@onready var tile_map_layer: TileMapLayer = get_node("TileMapLayer")
@onready var round_timer: Timer = get_node("RoundTimer")

const STARTING_ENEMIES: int = 2
const TIME_PER_ROUND: float = 1 # seconds

static var build_round: bool = true
static var enemy_array: Array[int]

var enemies = STARTING_ENEMIES:
	set(num):
		enemies = clamp(num, 0, 300)

func _ready() -> void:
	# dialogue starts
	# dialogue eventually ends
	round_timer.wait_time = TIME_PER_ROUND
	round_timer.start()
	print("main entered scene tree")


func start_wave(enemy_count) -> void:
	build_round = false
	for i in range(enemy_count):
		enemy_array.append(0)
	
	print("inside main", enemy_array)
	enemy_spawner.initialize_enemies(enemy_array)
	enemy_spawner.spawn_enemy()


func _unhandled_input(event: InputEvent) -> void:
	if build_round:
		if event.is_action_pressed("left_mouse"):
			var cell_pos: Vector2i = tile_map_layer.local_to_map(tile_map_layer.get_local_mouse_position())
			building_manager.place_tower(cell_pos, tower_packed_scene)
		
		if event.is_action_pressed("right_mouse"):
			var cell_pos: Vector2i = tile_map_layer.local_to_map(tile_map_layer.get_local_mouse_position())
			building_manager.remove_tower(cell_pos)


func _enter_build_round() -> void:
		enemy_array.clear()
		build_round = true
		enemies += (enemies/2) + 1
		round_timer.start()


func _on_round_timer_timeout() -> void:
	round_timer.stop()
	build_round = false
	print("timer started")
	start_wave(enemies)
