extends Control

class_name BuildingCardUI

signal card_hovered(card : BuildingCardUI)

@export var _texture_rect : TextureRect
@export var name_label : RichTextLabel
@export var price_label : RichTextLabel

var building : GridBuildingData

@export var container : Control

func set_building(_building: GridBuildingData):
	_texture_rect.texture = _building.sprite
	name_label.text = _building.building_name
	price_label.text = str(_building.gold_cost)
	building = _building

func _on_mouse_entered() -> void:
	scale *= 1.2
	card_hovered.emit(self)

func _on_mouse_exited() -> void:
	scale = Vector2(1,1)


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_released("left_mouse_click"):
		SignalBus.building_card_ui_clicked.emit(building)
