class_name WaterTurret
extends Turret


enum Type {BASIC, FREEZER, STORM}

@export var turret_type: Type = Type.STORM

var water_attack_scene: PackedScene = preload("res://scenes/main/weapon/water_attack/water_attack.tscn")
var killable_enemies: Array[Enemy]:
	set(new_killable_enemies):
		killable_enemies = new_killable_enemies
		if killable_enemies.size() == 0:
			is_firing = false
@onready var marker: Marker2D = $Placeholder/Marker2D

func _ready() -> void:
	super._ready()
	
	match (turret_type):
		Type.FREEZER:
			damage_rate = 3
		Type.STORM:
			damage_rate = 7
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
		is_firing = false
	if killable_enemies.size() > 0:
		killable_enemies.erase(body as Enemy)


func _on_shoot_timer_timeout() -> void:
	if target != null:
		call_deferred("shoot")
		shoot_timer.start()


func _on_is_firing() -> void:
	call_deferred("shoot")
	shoot_timer.start()


func shoot():
	var water_attack := water_attack_scene.instantiate()
	match (turret_type):
		Type.STORM:
			pass
		_:
			water_attack.position = marker.global_position
	water_attack.attack_type = turret_type
	water_attack.target = target
	get_tree().get_root().add_child(water_attack)
	killable_enemies.erase(target)
	target = null
