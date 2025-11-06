extends VBoxContainer

class_name BuildingCardUI

@export var _texture_rect : TextureRect
@export var label : RichTextLabel

var building : GridBuildingData

func set_building(_building: GridBuildingData):
	pass
	_texture_rect.texture = _building.sprite
	label.text = _building.building_name
	building = _building

func _on_button_pressed() -> void:
	SignalBus.building_card_ui_clicked.emit(building)
