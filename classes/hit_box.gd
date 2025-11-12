class_name HitBox extends Area2D

@export var damage_data : Damage

func _ready():
	area_entered.connect(_on_area_entered)
	
func _on_area_entered(area : HurtBox):
	area.take_damage(damage_data, self)
