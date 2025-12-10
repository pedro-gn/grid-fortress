extends CharacterBody2D
class_name Projectile

# --- Components ---
@onready var sprite: Sprite2D = $Sprite2D
@export var hit_box: HitBox

# --- Properties ---
var speed: float
var motion_style: ProjectileSpawner.MotionStyle
var tracking_mode: ProjectileSpawner.TrackingMode
var gravity: float
var tower_global_position : Vector2

# --- 2.5D Physics ---
var height: float = 0.0
var z_velocity: float = 0.0

# --- Target Data ---
var target_node: Node2D
var target_pos: Vector2
var direction_vector: Vector2 

func _ready() -> void:
	hit_box.max_hits_reached.connect(_on_hit_box_max_hits_reached)

func _on_hit_box_max_hits_reached():
	queue_free.call_deferred()

func setup(_tower_global_position: Vector2, _target: Node2D, _speed: float, _style: ProjectileSpawner.MotionStyle, _tracking: ProjectileSpawner.TrackingMode, _gravity_scale: float, _start_height: float):
	self.target_node = _target
	self.speed = _speed
	self.motion_style = _style
	self.tracking_mode = _tracking
	self.gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * _gravity_scale
	self.height = _start_height
	tower_global_position = _tower_global_position
	
	# Initial Target Setup
	if is_instance_valid(target_node):
		target_pos = target_node.global_position

	look_at(target_pos)
	direction_vector = global_position.direction_to(target_pos)
	
	if motion_style == ProjectileSpawner.MotionStyle.CURVE:
		_calculate_ballistics()
		
	post_setup()

func _calculate_ballistics():
	var distance = global_position.distance_to(target_pos)
	var flight_time = distance / speed
	
	if flight_time > 0:
		# Calculate the initial upward velocity (Jump force)
		var gravity_part = 0.5 * gravity * flight_time
		var height_compensation = -height / flight_time
		z_velocity = gravity_part + height_compensation

func _physics_process(delta: float):
	# 1. Update Target (Homing)
	if tracking_mode == ProjectileSpawner.TrackingMode.HOMING and is_instance_valid(target_node):
		target_pos = target_node.global_position
		direction_vector = global_position.direction_to(target_pos)

	# 2. Horizontal Movement (Map X/Y)
	var current_pos = global_position
	var new_pos = current_pos.move_toward(target_pos, speed * delta)
	
	# Update Facing Direction (Parent Node)
	if current_pos.distance_squared_to(new_pos) > 0.1:
		look_at(new_pos)
		
	global_position = new_pos

	# 3. Vertical Movement (Z-Axis)
	if motion_style == ProjectileSpawner.MotionStyle.CURVE:
		z_velocity -= gravity * delta
		height += z_velocity * delta
		
		# Floor Check
		if height <= 0:
			height = 0
			_on_impact()

	# 4. Update Visuals
	_process_visuals()

func _process_visuals():
	if motion_style == ProjectileSpawner.MotionStyle.CURVE:
		# --- Perspective Calculation ---
		# abs(direction.x) -> 1.0 = Horizontal Shot (Full Arc), 0.0 = Vertical Shot (Flat Arc)
		var perspective_factor = abs(direction_vector.x)
		perspective_factor = clamp(perspective_factor, 0, 1.0) # Clamp to keep some arc visible
		
		# 1. Height Offset (Y-Axis)
		if direction_vector.x <= 0:
			sprite.position.y = height * perspective_factor
		else:
			sprite.position.y = -height * perspective_factor
		
		# 2. Rotation (Pitch)
		# Calculate angle based on vertical velocity vs forward speed
		# atan2(-z, speed) gives negative angle (nose up) when rising
		var arc_angle = atan2(-z_velocity, speed)
		
		# Apply perspective to angle
		arc_angle *= perspective_factor
		
		if direction_vector.x <= 0:
			sprite.rotation = -arc_angle
		else:
			sprite.rotation = arc_angle
	else:
		sprite.position.y = -height
		sprite.rotation = 0

func _on_impact():
	queue_free.call_deferred()

func post_setup():
	pass
