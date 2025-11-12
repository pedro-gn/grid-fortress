extends GridBuildingBase

@onready var target_acquisition_component: TargetAcquisitionComponent = $TargetAcquisitionComponent
@onready var projectile_spawner: ProjectileSpawner = $ProjectileSpawner

@export var base_fire_rate : float = 1

var _can_shoot : bool = true

func _physics_process(_delta: float) -> void:
	if target_acquisition_component.has_target() and _can_shoot :
		shoot()
		

func shoot():
	print("shoot")
	projectile_spawner.shoot(target_acquisition_component.get_closest_target())
	_can_shoot = false
	await get_tree().create_timer(base_fire_rate).timeout
	_can_shoot = true
	
