extends Control
class_name BuildingsUI

@export var building_card_scene : PackedScene

@export var grid_container: GridContainer 
@export var description_label: RichTextLabel 

func _ready() -> void:
	for building : GridBuildingData in Databases.grid_buildings.values():
		var card_instance : BuildingCardUI = building_card_scene.instantiate()
		card_instance.set_building(building)
		card_instance.card_hovered.connect(_on_card_hovered)
		grid_container.add_child(card_instance)


func _on_card_hovered(card : BuildingCardUI):
	description_label.text = card.building.description
