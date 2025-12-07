extends Weapon

enum Type {BASIC, FLAMETHROWER, EXPLOSION}

@export var fire_attack_type: Type = Type.EXPLOSION
@onready var animation_player: AnimationPlayer = $AnimationPlayer

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

func _ready() -> void:
	animation_player.play("RESET")
	match (fire_attack_type):
		Type.FLAMETHROWER:
			pass
		Type.EXPLOSION:
			animation_player.play("explode")
			await animation_player.animation_finished
			queue_free()
		_:
			pass


func _on_body_entered(body: Node2D) -> void:
	if "Enemy" in body.name:
		if body != null:
			body.take_damage(damage)
