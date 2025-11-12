extends Resource
class_name Health

@export var max_health : float 
@export var physical_armor : float 
@export var magic_defense : float

var current_health


func init() -> void:
	current_health = max_health

func take_damage(damage : Damage) -> float:
	current_health -= damage.physical_damage
	current_health -= damage.magical_damage
	return current_health
