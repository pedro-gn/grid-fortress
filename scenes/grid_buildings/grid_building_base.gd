extends AnimatableBody2D
class_name GridBuildingBase

@onready var buff_manager: BuffManager = %BuffManager

var _is_dragging : bool

func set_is_dragging(value : bool) -> void :
	_is_dragging = value
