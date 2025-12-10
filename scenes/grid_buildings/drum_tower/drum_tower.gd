extends GridBuildingBase

@export var attack_speed_buff : float = 0.1

@onready var influence_area: Area2D = %InfluenceArea

func _on_influence_area_body_entered(tower: GridBuildingBase) -> void:
	tower.buff_manager.add_attack_speed_buff(self, attack_speed_buff)

func _on_influence_area_body_exited(tower: GridBuildingBase) -> void:
	tower.buff_manager.remove_attack_speed_buff(self)
