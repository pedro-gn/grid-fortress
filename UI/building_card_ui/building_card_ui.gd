extends Control

class_name BuildingCardUI

@export var _texture_rect : TextureRect
@export var name_label : RichTextLabel
@export var price_label : RichTextLabel

var building : GridBuildingData

func set_building(_building: GridBuildingData):
	_texture_rect.texture = _building.sprite
	name_label.text = _building.building_name
	price_label.text = str(_building.gold_cost)
	building = _building
	
	
func _on_button_pressed() -> void:
	SignalBus.building_card_ui_clicked.emit(building)
