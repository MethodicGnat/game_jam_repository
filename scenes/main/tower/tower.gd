class_name Turret
extends Node2D

signal target_acquired
signal target_lost

const TURRET_GROUP: String = "TURRET_GROUP"

@onready var shoot_timer: Timer
var texture: Texture2D
var target: Enemy:
	set(new_target):
		target = new_target
		if target == null:
			target_lost.emit()
		else:
			target_acquired.emit()
var damage_rate: float:
	set(new_damage_rate):
		damage_rate = new_damage_rate
		if shoot_timer != null:
			shoot_timer.wait_time = damage_rate
var is_firing: bool = false:
	set(firing):
		is_firing = firing
		if is_firing:
			_on_is_firing()

func _ready() -> void:
	add_to_group("TURRET_GROUP")
	target_acquired.connect(_on_target_acquired)
	target_lost.connect(_on_target_lost)


func _physics_process(_delta: float) -> void:
	look_at(target.position)


func shoot() -> void:
	pass


func upgrade() -> void:
	pass


func _on_target_acquired() -> void:
	pass


func _on_target_lost() -> void:
	rotation = 0


func _on_is_firing() -> void:
	pass
