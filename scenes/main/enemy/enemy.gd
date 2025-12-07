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
const DEFAULT_FIRE_TICK_SPEED: float = 0.4

@onready var sprite: ColorRect = $Sprite2D
@onready var enemy_spawner: EnemySpawner = get_parent().find_child("EnemySpawner")
@onready var target_pos: Marker2D = get_parent().find_child("EndPos")
@onready var pathfinding_manager: PathfindingManager = get_tree().get_nodes_in_group(MANAGER_GROUP)[1]
@onready var _path_array: Array[Vector2i] = pathfinding_manager.get_valid_path(global_position / 64, target_pos.position / 64)
@onready var burn_effect: CPUParticles2D = $BurnEffect
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_dead_to_turret: bool = false
var fire_tick_speed: float = DEFAULT_FIRE_TICK_SPEED

func _ready() -> void:
	name = "Enemy"
	pathfinding_manager = pathfinding_manager.duplicate()
	_path_array = _path_array.duplicate() # optimize this later
	died.connect(enemy_spawner._count_deaths)
	
	enemy_type = randi_range(0, Type.size()) as Type
	
	match(enemy_type):
		Type.EARTH:
			scale = Vector2(3, 3)
			sprite.color = Color(0.533, 0.267, 0.0, 1.0)
			movement_speed = 100
			health = 333
			z_index = 2
		Type.WIND:
			sprite.color = Color(0.871, 1.0, 1.0, 1.0)
			scale = Vector2(0.75, 0.75)
			movement_speed = 750
			health = 50
		Type.FIRE:
			sprite.color = Color(1.0, 0.392, 0.251, 1.0)
			movement_speed = 300
			health = 150
		_:
			movement_speed = 200


func _physics_process(_delta: float) -> void:
	if !Main.build_round:
		get_path_to_position()
		move_and_slide()


func take_damage(damage: int) -> void:
	is_dead_to_turret = true
	animation_player.play("damage_taken")
	health -= damage


func burn(burn_level: FireAttack.Type, damage: int) -> void:
	var ticks: int
	match burn_level:
		FireAttack.Type.BASIC:
			ticks = 10
		_:
			ticks = health/damage
	burn_effect.emitting = true
	for i in range(ticks):
		take_damage(damage)
		await get_tree().create_timer(fire_tick_speed).timeout
	burn_effect.emitting = false


func get_path_to_position() -> void:
	if len(_path_array) > 0:
		var direction: Vector2 = global_position.direction_to(self._path_array[0])
		velocity = direction * movement_speed
		if global_position.distance_to(self._path_array[0]) < 10:
			self._path_array.remove_at(0)
	else:
		velocity = Vector2.ZERO


func _on_end_area_entered(area: Area2D) -> void:
	if area.name == "Out":
		is_dead_to_turret = false
		health = 0
