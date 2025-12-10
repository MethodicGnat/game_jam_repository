class_name HomingMissile
extends CharacterBody2D


var bullet_type: GunTurret.Type

var damage: float
var speed: float
var target: Enemy = null


func _ready() -> void:
	match (bullet_type):
		GunTurret.Type.SNIPER:
			scale = Vector2(3, 0.5)
			damage = 9999
			speed = 2000
		GunTurret.Type.MINIGUN:
			scale = Vector2(1, 1)
			damage = 3
			speed = 1250
		_:
			scale = Vector2(2, 1)
			damage = 33
			speed = 1250


func _physics_process(_delta: float) -> void:
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
