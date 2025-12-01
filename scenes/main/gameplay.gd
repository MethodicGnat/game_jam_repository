class_name Main
extends Node2D

@export var tower_packed_scene: PackedScene
@export var building_manager: BuildingManager
@export var enemy_spawner: EnemySpawner
@onready var tile_map_layer: TileMapLayer = get_node("TileMapLayer")
@onready var round_timer: Timer = get_node("RoundTimer")
@onready var shop: Control = $CanvasLayer/Shop
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var score_label = $CanvasLayer/Victory/VBoxContainer/ScoreLabel/Score
@onready var currency_label: Label = $CanvasLayer/CurrencyLabel/Currency

const STARTING_ENEMIES: int = 2
const TIME_PER_ROUND: float = 60 # seconds
const IMPORTANT_LABELS: String = "IMPORTANT_LABELS"

static var build_round: bool = true
static var enemy_array: Array[int]
var rounds: int = 0:
	set(new_rounds):
		rounds = new_rounds - 1
var score: int = 0:
	set(new_score):
		score = new_score
		currency += (score * 100)
		score_label.text = str(score)
var currency: int = 0:
	set(new_currency):
		currency = new_currency
		currency_label.text = str(currency)

var enemies = STARTING_ENEMIES:
	set(num):
		enemies = clamp(num, 0, 300)

func _ready() -> void:
	# dialogue starts
	# dialogue eventually ends
	round_timer.wait_time = TIME_PER_ROUND
	round_timer.start()


func start_wave(enemy_count) -> void:
	build_round = false
	for i in range(enemy_count):
		enemy_array.append(0)
	
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
		
		if event.is_action_pressed("toggle_shop"):
			shop.visible = !shop.visible


func _enter_build_round() -> void:
		enemy_array.clear()
		build_round = true
		enemies += (enemies/2) + 1
		round_timer.start()


func _on_new_score(score: int) -> void:
	self.score += score


func _on_round_timer_timeout() -> void:
	round_timer.stop()
	build_round = false
	rounds += 1
	
	start_wave(enemies)
