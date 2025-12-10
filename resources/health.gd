extends Resource
class_name Health

@export var max_health : float 
@export var physical_armor : float 
@export var magic_defense : float

var current_health
var current_physical_armor : float
var current_magic_defense : float


var poison_timer : float = 0

func init() -> void:
	current_health = max_health
	current_physical_armor = physical_armor
	current_magic_defense = magic_defense
	
func take_damage(damage : Damage) -> float:
	current_health -= damage.magical_damage 
	
	var armor_constant = 100.0 
	var reduction_factor = current_physical_armor / (current_physical_armor + armor_constant)
	var final_physical_damage = damage.physical_damage * (1.0 - reduction_factor)
	current_health -= final_physical_damage
	
	
	poison_timer = damage.poison_time
	
	return current_health



func reset_armor():
	current_physical_armor = physical_armor

func tick(delta : float):
	if poison_timer > 0:
		poison_timer -= delta

		current_health -= StatusEffects.poison_damage_per_sec * delta
		current_physical_armor = physical_armor * (1 - StatusEffects.poison_armor_reduction)
		
		if poison_timer <= 0:
			poison_timer = 0
			reset_armor()
