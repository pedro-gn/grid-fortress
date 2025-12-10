extends CanvasLayer

@export_category("Nodes")
@export var tower: Tower
@export var resource_manager : ResourcesManager
@export var spawner : EnemySpawner

@export_category("UI Nodes")
@export var tower_health_ui : TowerHealthUI
@export var resources_ui : ResourcesUI
@export var waves_ui : WavesUI

func _ready() -> void:
	tower.health_changed.connect(tower_health_ui.on_health_changed)
	resource_manager.gold_changed.connect(resources_ui._on_gold_changed)
	
	spawner.wave_changed.connect(waves_ui._on_wave_changed)
	spawner.time_to_next_wave_updated.connect(waves_ui._on_timer_updated)
	spawner.wave_spawning_started.connect(waves_ui._on_wave_started)
	spawner.all_waves_completed.connect(waves_ui._on_all_completed)
	spawner.wave_progress_updated.connect(waves_ui._on_wave_progress_updated)
	
	waves_ui.start_wave_button_pressed.connect(spawner.start)
