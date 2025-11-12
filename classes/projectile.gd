extends CharacterBody2D



@export var hit_box : HitBox

# --- Enums from the Spawner ---
enum MotionStyle { STRAIGHT, CURVE }
enum TrackingMode { HOMING, TARGET_POSITION }

# --- Projectile Properties ---
var speed: float = 600.0
var motion_style: MotionStyle = MotionStyle.STRAIGHT
var tracking_mode: TrackingMode = TrackingMode.TARGET_POSITION
var gravity_scale: float = 1.0 # The spawner will set this

# --- Target Variables ---
var target_node: Node2D = null # For HOMING
var target_pos: Vector2 = Vector2.ZERO # For TARGET_POSITION

# This is the "gravity" value passed from the Godot project settings
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

# --- Setup Function ---
# The Spawner calls this function immediately after instancing the projectile.
func setup(_target: Node2D, _speed: float, _style: MotionStyle, _tracking: TrackingMode, _gravity_scale: float):
	self.speed = _speed
	self.motion_style = _style
	self.tracking_mode = _tracking
	self.gravity_scale = _gravity_scale

	if is_instance_valid(_target):
		self.target_node = _target
		self.target_pos = _target.global_position
	else:
		# Target is already gone? Just aim at its last known spot.
		self.target_pos = _target.global_position if _target else self.global_position
		self.tracking_mode = TrackingMode.TARGET_POSITION

	# Set initial velocity
	var direction = global_position.direction_to(target_pos)
	
	if motion_style == MotionStyle.STRAIGHT:
		# For straight motion, velocity is constant.
		velocity = direction * speed
	elif motion_style == MotionStyle.CURVE:
		# For curved (arrow) motion, we calculate an initial velocity
		# to create an arc. This is a simple ballistic calculation.
		# Note: This is tricky. A simpler way is to just add an "upward" kick.
		
		# Simple Arc Method: Aim slightly above the target.
		# This isn't perfect physics, but works well for games.
		var distance = global_position.distance_to(target_pos)
		var upward_kick = (distance / speed) * gravity * gravity_scale * 0.5
		
		# If the target is below us, we might not need a big kick.
		upward_kick = max(0, upward_kick - (target_pos.y - global_position.y))
		
		var velocity_dir = (target_pos - global_position).normalized()
		velocity = velocity_dir * speed
		velocity.y -= upward_kick # Add the "arc"
		
		# Ensure we are always looking forward
		rotation = velocity.angle()

func _ready() -> void:
	hit_box.area_entered.connect(_on_hit_box_area_entered)

func _on_hit_box_area_entered(_area : Area2D):
	queue_free()

func _physics_process(delta: float):
	# --- 1. Apply Gravity (for CURVE motion) ---
	if motion_style == MotionStyle.CURVE:
		velocity.y += gravity * gravity_scale * delta

	# --- 2. Handle Tracking & Movement ---
	if tracking_mode == TrackingMode.HOMING:
		if is_instance_valid(target_node):
			# Homing: Constantly update direction towards the target
			var direction = global_position.direction_to(target_node.global_position)
			velocity = velocity.move_toward(direction * speed, speed * 2 * delta) # Slerp-like
		else:
			# Target lost, just continue straight
			tracking_mode = TrackingMode.TARGET_POSITION
			
	elif tracking_mode == TrackingMode.TARGET_POSITION:
		pass

	# --- 3. Update Rotation & Move ---
	# Always point in the direction of velocity
	if velocity.length() > 0:
		rotation = velocity.angle()
	
	move_and_slide()

	if get_slide_collision_count() > 0:
		# Optional: Ricochet or destroy
		print("Projectile hit a wall!")
		queue_free() # Destroy on wall impact
