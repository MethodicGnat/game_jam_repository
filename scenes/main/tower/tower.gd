class_name Turret
extends Node2D

signal target_acquired
signal target_lost

var target: Enemy:
	set(new_target):
		target = new_target
		if target == null:
			target_lost.emit()
		else:
			target_acquired.emit()
var damage_rate: float
var is_firing: bool = false:
	set(firing):
		is_firing = firing
		if is_firing:
			_on_is_firing()

func _ready() -> void:
	target_acquired.connect(_on_target_acquired)
	target_lost.connect(_on_target_lost)


func _physics_process(delta: float) -> void:
	look_at(target.position)


func shoot() -> void:
	pass


func _on_target_acquired() -> void:
	pass


func _on_target_lost() -> void:
	pass


func _on_is_firing() -> void:
	pass
