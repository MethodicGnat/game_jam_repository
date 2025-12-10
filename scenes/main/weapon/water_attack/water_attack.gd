class_name WaterAttack
extends CharacterBody2D


@onready var animation_player: AnimationPlayer = $AnimationPlayer

var attack_type: WaterTurret.Type
var damage: float
var speed: float
var target: Enemy = null
var slow: float # % slow

func _ready() -> void:
	add_to_group(Weapon.WEAPONS_GROUP)	
	animation_player.play("RESET")
	match (attack_type):
		WaterTurret.Type.FREEZER:
			damage = 10
			speed = 2000
			slow = 1
			animation_player.play("freeze")
		WaterTurret.Type.STORM:
			damage = 3
			speed = 1250
			slow = 0.33
			animation_player.play("flood")
			await animation_player.animation_finished
			queue_free()
		_:
			damage = 10
			speed = 1000
			slow = 0.15


func _physics_process(_delta: float) -> void:
	if !attack_type == WaterTurret.Type.STORM:
		if target != null:
			velocity = global_position.direction_to(target.position) * speed
			
			look_at(target.position)
			
			move_and_slide()
		if target == null:
			queue_free()

func _on_body_entered(body: Node2D) -> void:
	if "Enemy" in body.name:
		if attack_type == WaterTurret.Type.BASIC:
			remove_from_group(Weapon.WEAPONS_GROUP)
			queue_free()
		body.slow(slow, damage)
