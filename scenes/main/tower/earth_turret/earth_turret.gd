extends Turret


const STARTING_DAMAGE_INCREMENT = 1
const STARTING_DAMAGE_RATE_INCREMENT = 0.25

var damage_increment: int
var damage_rate_increment: float

func _init() -> void:
	damage_rate = 7
	damage_increment = STARTING_DAMAGE_INCREMENT
	damage_rate_increment = STARTING_DAMAGE_RATE_INCREMENT
	

func _ready() -> void:
	is_firing = true


func _on_is_firing() -> void:
	for weapon in get_tree().get_nodes_in_group(Weapon.WEAPONS_GROUP):
		print(weapon.damage)
		weapon.damage += damage_increment
		print(weapon.damage)
	for turret in get_tree().get_nodes_in_group(Turret.TURRET_GROUP):
		print(turret.damage_rate)
		turret.damage_rate -= damage_rate_increment
		print(turret.damage_rate)
