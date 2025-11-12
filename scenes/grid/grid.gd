extends Node2D
class_name Grid

@export var grid_slot_scene: PackedScene

@export_category("Dimensões da Grid")
@export var width: int = 10
@export var height: int = 8

@export_category("Aparência")
@export var spacing: Vector2 = Vector2(64, 64)

@onready var label: Label = $CanvasLayer/HBoxContainer/Label
@onready var label_2: Label = $CanvasLayer/HBoxContainer/Label2
@onready var label_3: Label = $CanvasLayer/HBoxContainer/Label3

@export_category("TileMaps")
@export var sprites_tilemap_layer : TileMapLayer
@export var navigation_tilemap_layer : NavigationTileMapLayer

var selected_slot : GridSlot
var selected_building : GridBuildingBase

var slots : Array[GridSlot] = []

var _hovered_slot : GridSlot = null

func _ready() -> void:
	generate_grid()
	SignalBus.building_card_ui_clicked.connect(_on_building_card_ui_clicked)

func _process(_delta: float) -> void:
	label.text = "Selected Slot: " + str(selected_slot)
	label_2.text = "Selected building: " + str(selected_building)
	label_3.text = "Hovering slot" + str(_hovered_slot)
	if selected_building :
		selected_building.global_position = get_global_mouse_position()

func generate_grid() -> void:
	if not grid_slot_scene:
		print("A cena 'grid_slot_scene' não foi definida no GridGenerator!")
		return
	
	for y in range(height):
		for x in range(width):
			var slot_instance : GridSlot = grid_slot_scene.instantiate()

			var slot_position = Vector2(x * spacing.x, y * spacing.y)

			slot_instance.position = slot_position
			add_child(slot_instance)
			slots.append(slot_instance)
			slot_instance.set_grid_coords(Vector2i(x,y))
			slot_instance.mouse_entered.connect(_on_slot_mouse_entered)
			slot_instance.mouse_exited.connect(_on_slot_mouse_exited)
			
func _on_slot_mouse_entered(slot: GridSlot):
	_hovered_slot = slot

func _on_slot_mouse_exited(_slot: GridSlot):
	_hovered_slot = null

func _input(event: InputEvent) -> void:
	if event.is_action_released("left_mouse_click") and selected_building:
		
		# Case 1: Mouse released over a valid slot (the hovered_slot)
		if _hovered_slot and _hovered_slot != selected_slot:
			if _hovered_slot.is_free(): # Drag to empty slot
				_hovered_slot.set_building(selected_building)
				navigation_tilemap_layer.close_nav_cell(_hovered_slot.grid_coords)
				if selected_slot:
					navigation_tilemap_layer.set_nav_cell(selected_slot.grid_coords)
					selected_slot.unset_building()
			else:  #Drag to another slot and swap
				var building_to_swap = _hovered_slot.grid_building
				_hovered_slot.set_building(selected_building)
				selected_slot.set_building(building_to_swap)
		else:
			if selected_slot:
				selected_building.global_position = selected_slot.global_position
			else:
				selected_building.queue_free()
		selected_slot = null
		selected_building = null
	elif event.is_action_released("left_mouse_click") and !selected_building and _hovered_slot:
		selected_building = _hovered_slot.grid_building
		selected_slot = _hovered_slot


func has_free_slot() -> bool:
	for slot in slots:
		if slot.is_free():
			return true
	return false

func _on_building_card_ui_clicked(building : GridBuildingData):
	if has_free_slot():
		var building_instance : GridBuildingBase = building.building_scene.instantiate()
		add_child(building_instance)
		selected_building = building_instance
