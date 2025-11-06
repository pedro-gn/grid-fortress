extends Control
class_name BuildingsUI

@export var building_card_scene : PackedScene

@onready var grid_container: GridContainer = $GridContainer

func _ready() -> void:
	for building : GridBuildingData in Databases.grid_buildings.values():
		var card_instance : BuildingCardUI = building_card_scene.instantiate()
		card_instance.set_building(building)
		grid_container.add_child(card_instance)
