extends GridBuildingBase

@onready var target_acquisition_component: TargetAcquisitionComponent = $TargetAcquisitionComponent
@onready var projectile_spawner: ProjectileSpawner = $ProjectileSpawner

func _physics_process(delta: float) -> void:
	if target_acquisition_component.has_target() :
		projectile_spawner.shoot(target_acquisition_component.get_closest_target())
