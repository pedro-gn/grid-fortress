extends Node2D
class_name GridSlot

signal left_mouse_down(grid_slot : GridSlot)
signal left_mouse_up(grid_slot : GridSlot)
signal mouse_entered(grid_slot : GridSlot)
signal mouse_exited(grid_slot : GridSlot)

var grid_building : GridBuildingBase = null

var grid_coords : Vector2i

func _process(_delta: float) -> void:
	pass

func set_grid_coords( coords : Vector2i ) -> void : 
	grid_coords = coords

func is_free():
	return grid_building == null

func set_building(building : GridBuildingBase):
	grid_building = building
	grid_building.global_position = global_position

func unset_building():
	if grid_building:
		grid_building = null

func _on_mouse_detector_mouse_entered() -> void:
	mouse_entered.emit(self)

func _on_mouse_detector_mouse_exited() -> void:
	mouse_exited.emit(self)

func _on_mouse_detector_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse_click"):
		left_mouse_down.emit(self)
	if event.is_action_released("left_mouse_click"):
		left_mouse_up.emit(self)
