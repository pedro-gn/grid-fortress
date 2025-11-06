extends Node2D
class_name ProjectileSpawner

## --- Configuration ---
# These enums define the options available in the Inspector.
enum MotionStyle { 
	STRAIGHT, # Bullet, magic bolt
	CURVE     # Arrow, grenade
}

enum TrackingMode { 
	HOMING,           # Follows the target
	TARGET_POSITION   # Aims at the target's initial spot
}

@export_group("Projectile")
## The scene file for the projectile to spawn (e.g., Projectile.tscn)
@export var projectile_scene: PackedScene

@export_group("Stats")
## The base speed of the projectile in pixels/sec.
@export var projectile_speed: float = 600.0
## How much gravity affects the projectile (0 = no gravity).
@export var gravity_scale: float = 1.0

@export_group("Behavior")
## The movement style of the projectile.
@export var motion_style: MotionStyle = MotionStyle.STRAIGHT
## The tracking behavior of the projectile.
@export var tracking_mode: TrackingMode = TrackingMode.TARGET_POSITION


## --- Main Function ---
## Call this function from your Player or Enemy script to fire.
func shoot(target: Node2D):
	if not projectile_scene:
		print("ProjectileSpawner: 'projectile_scene' is not set!")
		return

	# Make sure the target is valid
	if not is_instance_valid(target):
		print("ProjectileSpawner: Target is not valid!")
		return

	# --- 1. Instance the Projectile ---
	var projectile = projectile_scene.instantiate()
	
	# Check if the projectile has the correct setup function
	if not projectile.has_method("setup"):
		print("Projectile scene is missing the 'setup' function!")
		projectile.queue_free()
		return

	# --- 2. Position the Projectile ---
	# Spawn it at the spawner's global position
	projectile.global_position = self.global_position

	# --- 3. Add to Scene Tree ---
	# Add it to the main root to prevent it from being deleted
	# if the spawner (e.g., an enemy) is deleted.
	get_tree().root.add_child(projectile)

	# --- 4. Configure the Projectile ---
	# Call its setup function to pass all our settings
	projectile.setup(
		target,
		projectile_speed,
		motion_style,
		tracking_mode,
		gravity_scale if motion_style == MotionStyle.CURVE else 0.0 # Only apply gravity if style is CURVE
	)
