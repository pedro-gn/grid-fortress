extends Node
class_name ResourcesManager

signal gold_changed(qnt : int)

var _gold : int = 990

func _ready() -> void:
	_setup.call_deferred()
	

func _setup():
	gold_changed.emit(_gold)
	SignalBus.enemy_died.connect(_on_enemy_died)
	SignalBus.gold_mined.connect(_on_gold_mined)
	
func _on_gold_mined(gold_qnt : int):
	add_gold(gold_qnt)

func _on_enemy_died(gold_value: int):
	add_gold(gold_value)
	
func get_gold_qnt() -> int:
	return _gold

func add_gold(qnt : int) -> void:
	_gold = clamp(_gold + qnt, 0, 999999)
	gold_changed.emit(_gold)
