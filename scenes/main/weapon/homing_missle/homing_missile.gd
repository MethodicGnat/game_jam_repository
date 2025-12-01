class_name HomingMissile
extends CharacterBody2D

var damage: int
var speed: float
var target: Enemy = null

func _init() -> void:
	damage = 35
	speed = 1250


func _physics_process(delta: float) -> void:
	if target != null:
		velocity = global_position.direction_to(target.position) * speed
		
		look_at(target.position)
		
		move_and_slide()
	if target == null:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if "Enemy" in body.name:
		self.queue_free()
		body.take_damage(damage)
