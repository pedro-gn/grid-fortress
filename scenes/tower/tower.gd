extends Node2D
class_name Tower

signal health_changed(max_health, current_health)

@export var tower_max_health : float = 10

var _current_health

func _ready() -> void:
	_current_health = tower_max_health
	health_changed.emit(tower_max_health, _current_health)


func _on_area_2d_body_entered(enemy: EnemyBase) -> void:
	if !enemy:
		return
	
	_current_health -= enemy.tower_damage
	health_changed.emit(tower_max_health, _current_health)
	enemy.queue_free.call_deferred()
