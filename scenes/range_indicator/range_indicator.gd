extends Node2D
class_name RangeIndicator

@export var visual : ColorRect

# Configuration
@export var radius: float = 150.0:
	set(value):
		radius = value
		update_visual()

@export var color: Color = Color(0.2, 0.6, 1.0, 0.3) # Default Blue

func _physics_process(_delta: float) -> void:
	if owner is GridBuildingBase:
		if (owner as GridBuildingBase)._is_dragging :
			visible = true
		else:
			visible = false

func _ready():
	update_visual()

func update_visual():
	if visual:
		# The ColorRect needs to be double the radius (diameter)
		var size = radius * 2
		visual.size = Vector2(size, size)
		visual.position = Vector2(-radius, -radius) # Center it
		
		# Pass data to shader
		var mat = visual.material as ShaderMaterial
		if mat:
			mat.set_shader_parameter("color", color)

# Call this from your Tower script
func set_active(active: bool):
	visible = active
