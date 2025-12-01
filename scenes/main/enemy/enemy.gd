class_name Enemy
extends CharacterBody2D

signal died(is_dead_to_turret)

enum Type {BASIC, EARTH, WIND, FIRE}
@export var enemy_type: Type = Type.BASIC
@export var movement_speed: float = 500
@export var health: int = 100:
	set(new_health):
		health = new_health
		if health <= 0:
			self.queue_free()
			died.emit(is_dead_to_turret)

const MANAGER_GROUP: String = "MANAGER"

@onready var enemy_spawner: EnemySpawner = get_parent().find_child("EnemySpawner")
@onready var target_pos: Marker2D = get_parent().find_child("EndPos")
@onready var pathfinding_manager: PathfindingManager = get_tree().get_nodes_in_group(MANAGER_GROUP)[1]
@onready var _path_array: Array[Vector2i] = pathfinding_manager.get_valid_path(global_position / 64, target_pos.position / 64)
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_dead_to_turret: bool = false

func _ready() -> void:
	name = "Enemy"
	pathfinding_manager = pathfinding_manager.duplicate()
	_path_array = _path_array.duplicate() # optimize this later
	died.connect(enemy_spawner._count_deaths)
	
	enemy_type = randi_range(0, Type.size()) as Type
	
	match(enemy_type):
		Type.EARTH:
			movement_speed = 100
		Type.WIND:
			movement_speed = 500
		Type.FIRE:
			movement_speed = 300
		_:
			movement_speed = 200

func _physics_process(_delta: float) -> void:
	if !Main.build_round:
		get_path_to_position()
		move_and_slide()


func take_damage(damage: int):
	is_dead_to_turret = true
	animation_player.play("damage_taken")
	health -= damage

func get_path_to_position() -> void:
	if len(_path_array) > 0:
		var direction: Vector2 = global_position.direction_to(self._path_array[0])
		velocity = direction * movement_speed
		if global_position.distance_to(self._path_array[0]) < 10:
			self._path_array.remove_at(0)
	else:
		velocity = Vector2.ZERO


func _on_end_area_entered(area: Area2D) -> void:
	var area_class = area.get_parent().get_class()
	if area.name == "Out":
		is_dead_to_turret = false
		health = 0
