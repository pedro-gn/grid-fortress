extends Control
class_name TowerHealthUI

@export var health_progress_bar : TextureProgressBar



func on_health_changed(max_health: float, current_healt: float ):
	health_progress_bar.max_value = max_health
	health_progress_bar.value = current_healt
