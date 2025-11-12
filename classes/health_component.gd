class_name HealthComponent extends Node

signal damage_taken(damage : float, knockback_force : Vector2, damage_dealer : Node2D)
signal health_changed(health_data : Health)
signal died(killed_by : Node2D)

@export var health_data : Health
@export var hurt_box : HurtBox
@export var health_bar : TextureProgressBar


func _ready():
	health_data.init()
	hurt_box.damage_taken.connect(_on_hurt_box_damage_taken)
	if health_bar:
		health_bar.max_value = health_data.max_health
		health_bar.value = health_data.current_health

func restore_full_health():
	pass


func _on_hurt_box_damage_taken(damage : Damage, damage_dealer : Node2D):
	health_data.take_damage(damage)
	health_changed.emit(health_data)
	
	
	if health_bar:
		health_bar.max_value = health_data.max_health
		health_bar.value = health_data.current_health

	if health_data.current_health <= 0:
		died.emit(damage_dealer)
