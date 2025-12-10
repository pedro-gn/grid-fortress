extends CharacterBody2D
class_name EnemyBase


@export_category("Stats")
@export var movement_speed: float = 100.0
@export var tower_damage : float = 1
@export var gold_value : int

@export_category("Components")
@export var health_component : HealthComponent
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

@export_category("Debug")
@export var move : bool = true

func _ready():
	if move == false:
		return
	
	navigation_agent.path_desired_distance = 4
	navigation_agent.target_desired_distance = 4.0
	health_component.died.connect(_on_died)
		
	actor_setup.call_deferred()

func _on_died(_killed_by : Node2D):
	queue_free()
	GlobalEffects.spawn_effect(global_position, GlobalEffects.EFFECTS.GOLD_EARN, gold_value)
	SignalBus.enemy_died.emit(gold_value)
	
func actor_setup():
	await get_tree().physics_frame
	set_movement_target(get_tree().get_first_node_in_group("Castle").global_position)

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

func _physics_process(_delta):
	if move == false:
		return
		
	if navigation_agent.is_navigation_finished():
		return

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()

	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	move_and_slide()
