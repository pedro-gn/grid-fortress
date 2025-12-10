extends Node
class_name BuffManager

signal range_multiplier_changed(range_multiplier : float)

var _range_multipliers = {}

var _attack_speed_multipliers = {}

func get_attack_speed_multiplyer() -> float:
	var total = 0
	for v in _attack_speed_multipliers.values():
		total += v
	
	return total

func add_attack_speed_buff(source, multiplyer : float) -> void:
	_attack_speed_multipliers[source] = multiplyer

func remove_attack_speed_buff(source) -> void:
	_attack_speed_multipliers.erase(source)

#======================= Range ===========================
func get_range_multiplyer() -> float:
	var total = 0
	for v in _range_multipliers.values():
		total += v
	
	return total

func add_range_buff(source, multiplyer : float) -> void:
	_range_multipliers[source] = multiplyer
	range_multiplier_changed.emit(get_range_multiplyer())
	
func remove_range_buff(source) -> void:
	_range_multipliers.erase(source)
	range_multiplier_changed.emit(get_range_multiplyer())
