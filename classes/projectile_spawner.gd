class_name ProjectileSpawner
extends Node2D

# --- Configuration ---
# We define enums here to expose them in the Inspector, 
# but we map them to the Projectile's logic.
enum MotionStyle { STRAIGHT, CURVE }
enum TrackingMode { HOMING, TARGET_POSITION }

@export var base_fire_rate : float = 1
@export var target_acquisition_component : TargetAcquisitionComponent
@export var buff_manager: BuffManager 

@export_group("Projectile Settings")
@export var projectile_scene: PackedScene
@export var projectile_speed: float = 600.0
@export var gravity_scale: float = 1.0
@export var spawn_height: float = 40.0 

@export_group("Behavior")
@export var motion_style: MotionStyle = MotionStyle.CURVE # Default to Curve to test your arc
@export var tracking_mode: TrackingMode = TrackingMode.TARGET_POSITION


var _can_shoot : bool = true
func _physics_process(_delta: float) -> void:
	if target_acquisition_component.has_target() and _can_shoot :
		shoot(target_acquisition_component.get_closest_target())

func shoot(target: Node2D) -> void:
	_can_shoot = false

	if not projectile_scene:
		push_warning("ProjectileSpawner: No scene assigned.")
		return
	
	if not is_instance_valid(target):
		return

	# 1. Instantiate
	var projectile = projectile_scene.instantiate() as Projectile
	if not projectile:
		push_error("ProjectileSpawner: Scene is not class 'Projectile'")
		return
	
	projectile.global_position = global_position
	
	get_tree().current_scene.add_child(projectile)

	projectile.setup(
		global_position,
		target,
		projectile_speed,
		motion_style, 
		tracking_mode,
		gravity_scale,
		spawn_height
	)
	
	var speed_bonus : float = 0.0
	if buff_manager:
		speed_bonus = buff_manager.get_attack_speed_multiplyer()
	
	var total_multiplier = 1.0 + speed_bonus
	
	var current_cooldown = base_fire_rate / total_multiplier
	await get_tree().create_timer(current_cooldown).timeout
	_can_shoot = true
