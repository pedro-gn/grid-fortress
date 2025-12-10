class_name TargetAcquisitionComponent extends Area2D

@export var base_area_radius : float = 120
@onready var buff_manager: BuffManager = %BuffManager
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var range_indicator: RangeIndicator = $"../RangeIndicator"

var targets_in_range : Array[Node2D] = []

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	buff_manager.range_multiplier_changed.connect(_on_range_multiplier_changed)
	collision_shape.shape.radius = base_area_radius
	range_indicator.radius = base_area_radius

func _on_range_multiplier_changed(new_multiplier : float):
	collision_shape.shape.radius = base_area_radius * (1 + new_multiplier)
	range_indicator.radius = base_area_radius * (1 + new_multiplier)

func _on_body_entered(body : Node2D):
	targets_in_range.append(body)

func _on_body_exited(body : Node2D) -> void:
	targets_in_range.erase(body)

func has_target() -> bool:
	return not targets_in_range.is_empty()

func get_targets_sorted_by_distance() -> Array[Node2D]:
	var my_position = global_position

	# Filter out invalid targets
	var valid_targets = targets_in_range.filter(func(target):
		return is_instance_valid(target)
	)

	# Sort targets by distance
	valid_targets.sort_custom(func(a, b):
		return my_position.distance_to(a.global_position) < my_position.distance_to(b.global_position)
	)

	return valid_targets

func get_closest_target():
	var closest_distance = INF
	var my_position = global_position
	var closest_target = null

	for target in targets_in_range:
		if not is_instance_valid(target):
			continue

		var distance = my_position.distance_to(target.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_target = target

	return closest_target
