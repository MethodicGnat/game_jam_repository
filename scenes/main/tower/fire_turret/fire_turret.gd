class_name FireTurret
extends Turret


enum Type {BASIC, FLAMETHROWER, EXPLOSION}

@export var fire_turret_type: Type = Type.EXPLOSION
@onready var marker: Marker2D = $Placeholder/Marker2D

var fire_attack_scene: PackedScene = preload("res://scenes/main/weapon/fire_attack/fire_attack.tscn")
var killable_enemies: Array[Enemy]

func _ready() -> void:
	super._ready()
	
	match (fire_turret_type):
		Type.FLAMETHROWER:
			damage_rate = 0.5
		Type.EXPLOSION:
			damage_rate = 4
		_:
			damage_rate = 2
	
	shoot_timer = $ShootTimer
	shoot_timer.wait_time = damage_rate


func _physics_process(delta: float) -> void:
	if killable_enemies.size() > 0:
		target = killable_enemies[0]
	if target != null:
		super._physics_process(delta)


func shoot() -> void:
	var fire_attack := fire_attack_scene.instantiate()
	fire_attack.position = marker.global_position
	fire_attack.fire_attack_type = fire_turret_type
	fire_attack.target = target
	get_tree().get_root().add_child(fire_attack)


func _on_shoot_timer_timeout() -> void:
	if killable_enemies.size() > 0:
		call_deferred("shoot")
		shoot_timer.start()
	else:
		is_firing = false


func _on_is_firing() -> void:
	call_deferred("shoot")
	shoot_timer.start()


func _on_body_entered(body: Node2D) -> void:
	if "Enemy" in body.name:
		killable_enemies.append(body)
		target = killable_enemies[0]
		if !is_firing:
			is_firing = !is_firing


func _on_body_exited(body: Node2D) -> void:
	if killable_enemies.size() > 0:
		killable_enemies.erase(body as Enemy)
	if killable_enemies.size() == 0:
		target = null
