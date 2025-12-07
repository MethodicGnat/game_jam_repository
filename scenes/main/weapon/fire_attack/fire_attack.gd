class_name FireAttack
extends Weapon

enum Type {BASIC, FLAMETHROWER, EXPLOSION}

@export var fire_attack_type: Type = Type.BASIC
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var target: Enemy

func _init() -> void:
	match fire_attack_type:
		Type.FLAMETHROWER:
			damage = 10
			speed = 0.25
		Type.EXPLOSION:
			damage = 9999
			speed = 1
		_:
			damage = 10
			speed = 0.75


func _physics_process(delta: float) -> void:
	if target == null:
		queue_free()
		return
	look_at(target.position)


func _ready() -> void:
	super._ready()
	animation_player.play("RESET")
	match (fire_attack_type):
		Type.EXPLOSION:
			animation_player.play("explode")
			await animation_player.animation_finished
			queue_free()
		_:
			animation_player.play("flame_thrower")


func _on_body_entered(body: Node2D) -> void:
	if "Enemy" in body.name:
		if body != null:
			match fire_attack_type:
				Type.EXPLOSION:
					body.take_damage(damage)
				_:
					body.burn(fire_attack_type, damage)
