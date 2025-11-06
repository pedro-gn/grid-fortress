class_name HitBox extends Area2D

@export var damage : float = 10
@export var knockback_force : Vector2 = Vector2(60,60)

func _ready():
	area_entered.connect(_on_area_entered)
	
func _on_area_entered(area : HurtBox):
	area.take_damage(damage, knockback_force, self)
