class_name EarthTurret
extends Turret


enum Type {BASIC, ULTIMATE}

const EARTH_TURRET_GROUP: String = "EARTH_TURRET_GROUP"
const STARTING_DAMAGE_INCREMENT: float = 0.05
const STARTING_DAMAGE_RATE_INCREMENT: float = 0.05

var damage_increment: float
var damage_rate_increment: float
var rounds: int

func _init() -> void:
	rounds = 0
	damage_increment = STARTING_DAMAGE_INCREMENT
	damage_rate_increment = STARTING_DAMAGE_RATE_INCREMENT
	

func _ready() -> void:
	add_to_group(EARTH_TURRET_GROUP)
	is_firing = true


func _on_is_firing() -> void:
	for weapon in get_tree().get_nodes_in_group(Weapon.WEAPONS_GROUP):
		weapon.damage += (1 + damage_increment)
	
	for turret in get_tree().get_nodes_in_group(Turret.TURRET_GROUP):
		turret.damage_rate *= (1 - damage_rate_increment)


func _on_round_end() -> void:
	is_firing = false
	rounds += 1
	damage_increment += (damage_increment * rounds)
	damage_rate_increment += (damage_rate_increment * rounds)
