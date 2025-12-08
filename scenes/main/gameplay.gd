class_name Main
extends Node2D

@export var tower_packed_scene: PackedScene
@export var building_manager: BuildingManager
@export var enemy_spawner: EnemySpawner
@export var inventory: Inventory

@onready var tile_map_layer: TileMapLayer = get_node("TileMapLayer")
@onready var build_round_timer: Timer = get_node("BuildRoundTimer")
@onready var shop: Control = $CanvasLayer/Shop
@onready var inventory_ui: Control = $CanvasLayer/Inventory
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var round_label: Label = $CanvasLayer/RoundLabel/Round
@onready var score_label = $CanvasLayer/Victory/VBoxContainer/ScoreLabel/Score
@onready var currency_label: Label = $CanvasLayer/CurrencyLabel/Currency

const STARTING_ENEMIES: int = 2
const MAX_ENEMIES_KILLED: int = 300
const TIME_PER_ROUND: float = 2 # seconds
const IMPORTANT_LABELS: String = "IMPORTANT_LABELS"

static var build_round: bool
static var enemy_array: Array[int]
var rounds: int:
	set(new_rounds):
		rounds = new_rounds
		round_label.text = str(rounds)
var score: int:
	set(new_score):
		score = new_score
		currency += (score * 100)
		score_label.text = str(score)
var currency: int:
	set(new_currency):
		currency = new_currency
		currency_label.text = str(currency)

var enemies: int:
	set(num):
		enemies = clamp(num, 0, MAX_ENEMIES_KILLED)

func _ready() -> void:
	# dialogue starts
	# dialogue eventually ends
	build_round = true
	enemy_array.clear()
	rounds = 0
	score = 0
	currency = 0
	inventory_ui.visible = false
	shop.visible = false
	enemies = STARTING_ENEMIES
	build_round_timer.wait_time = TIME_PER_ROUND
	
	animation_player.play("build round")
	await animation_player.animation_finished
	build_round_timer.start()


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
			inventory_ui.visible = false
			
	if event.is_action_pressed("toggle_inventory") and !shop.visible and !get_tree().paused:
		inventory_ui.visible = !inventory_ui.visible


func _enter_build_round() -> void:
	animation_player.play("RESET")
	enemy_array.clear()
	build_round = true
	enemies += enemies/2 + 1
	
	animation_player.play("build round")
	await animation_player.animation_finished
	build_round_timer.start()


func _on_new_score(score: int) -> void:
	self.score += score


func _on_build_round_timer_timeout() -> void:
	animation_player.play("RESET")
	build_round_timer.stop()
	build_round = false
	rounds += 1
	shop.visible = false
	
	animation_player.play("new round")
	await animation_player.animation_finished
	start_wave(enemies)
