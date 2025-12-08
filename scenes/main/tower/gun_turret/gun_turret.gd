class_name GunTurret
extends Turret


enum Type {BASIC, SNIPER, MINIGUN}

@export var gun_turret_type: Type = Type.MINIGUN

var bullet_packed_scene: PackedScene = preload("res://scenes/main/weapon/homing_missle/homing_missle.tscn")
var killable_enemies: Array[Enemy]:
	set(new_killable_enemies):
		killable_enemies = new_killable_enemies
		if killable_enemies.size() == 0:
			is_firing = false
@onready var marker: Marker2D = $Placeholder/Marker2D

func _ready() -> void:
	super._ready()
	
	match (gun_turret_type):
		Type.SNIPER:
			damage_rate = 3
		Type.MINIGUN:
			damage_rate = 0.1
		_:
			damage_rate = 1
	
	shoot_timer = $ShootTimer
	shoot_timer.wait_time = damage_rate


func _physics_process(delta: float) -> void:
	if killable_enemies.size() > 0:
		target = killable_enemies[0]
	if target != null:
		super._physics_process(delta)


func _on_body_entered(body: Node2D) -> void:
	if "Enemy" in body.name:
		killable_enemies.append(body)
		if !is_firing:
			is_firing = !is_firing


func _on_body_exited(body: Node2D) -> void:
	if body == target:
		target = null
	
	if killable_enemies.size() > 0:
		killable_enemies.erase(body as Enemy)
	else:
		is_firing = false


func _on_shoot_timer_timeout() -> void:
	if target != null:
		call_deferred("shoot")
		shoot_timer.start()


func _on_is_firing() -> void:
	call_deferred("shoot")
	shoot_timer.start()


func shoot():
	var bullet := bullet_packed_scene.instantiate()
	bullet.position = marker.global_position
	bullet.bullet_type = gun_turret_type
	bullet.target = target
	get_tree().get_root().add_child(bullet)
	target = null
