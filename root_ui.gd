extends CanvasLayer

@export_category("Nodes")
@export var tower: Tower

@export_category("UI Nodes")
@export var tower_health_ui : TowerHealthUI



func _ready() -> void:
	tower.health_changed.connect(tower_health_ui.on_health_changed)
