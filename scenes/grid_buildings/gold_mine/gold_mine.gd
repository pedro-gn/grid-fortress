extends GridBuildingBase

@export var gold_mined : int = 1
@export var mine_interval : float = 1
@export var effect_position_marker : Marker2D

var _mine_interval_timer : float

func _ready() -> void:
	_mine_interval_timer = mine_interval

func _process(delta: float) -> void:
	if _is_dragging:
		return
		
	_mine_interval_timer -= delta
	
	if _mine_interval_timer <= 0:
		GlobalEffects.spawn_effect(effect_position_marker.global_position,GlobalEffects.EFFECTS.GOLD_EARN, gold_mined)
		SignalBus.gold_mined.emit(gold_mined)
		_mine_interval_timer = mine_interval
