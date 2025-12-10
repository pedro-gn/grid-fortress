extends GridBuildingBase

@export var range_multiplyer : float = 0.2

func _on_influence_area_body_entered(tower: GridBuildingBase) -> void:
	print("ENTRO")
	if tower == self:
		return
	tower.buff_manager.add_range_buff(self, range_multiplyer)

func _on_influence_area_body_exited(tower: GridBuildingBase) -> void:
	if tower == self:
		return
	tower.buff_manager.remove_range_buff(self)
