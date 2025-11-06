extends Camera2D

# --- Movement Vars ---
@export var camera_speed := 500.0
@export var acceleration := 10.0
var velocity := Vector2.ZERO

# --- Zoom Vars ---
@export_category("Zoom")
@export var min_zoom := 1   
@export var max_zoom := 3.0   
@export var zoom_sensitivity := 0.1 # How much each scroll step adds/subtracts
@export var zoom_smoothing := 8.0   # How fast the zoom interpolates

# We use a Vector2 for zoom so we can lerp it
var target_zoom := Vector2.ONE 


func _ready() -> void:
	# Initialize target_zoom with the camera's current zoom at start
	target_zoom = zoom


func _input(event: InputEvent) -> void:
	# This function handles discrete events, like a single mouse click or scroll
	if event is InputEventMouseButton:
		
		# Check for "Wheel Up"MOUSE_BUTTON_WHEEL_DOWN
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN  and event.is_pressed():
			target_zoom -= Vector2(zoom_sensitivity, zoom_sensitivity)
		
		# Check for "Wheel Down"
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.is_pressed():
			target_zoom += Vector2(zoom_sensitivity, zoom_sensitivity)
		
		# Clamp the target zoom values so they don't go past min/max
		target_zoom.x = clamp(target_zoom.x, min_zoom, max_zoom)
		target_zoom.y = clamp(target_zoom.y, min_zoom, max_zoom)


func _physics_process(delta: float) -> void:
	# --- MOVEMENT ---
	# (This is the same smooth movement code as before)
	
	# 1. Get input direction
	var input_dir := Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down")
	
	# 2. Determine the target velocity
	var target_velocity := input_dir * camera_speed
	
	# 3. Smoothly interpolate velocity
	velocity = velocity.lerp(target_velocity, acceleration * delta)
	
	# 4. Apply the smoothed velocity
	global_position += velocity * delta


func _process(delta: float) -> void:
	# --- ZOOM ---
	# We run the zoom smoothing in _process (every frame)
	# because it's a visual effect, not a physics one.
	# This makes it feel smooth even if physics FPS is low.
	zoom = zoom.lerp(target_zoom, zoom_smoothing * delta)
