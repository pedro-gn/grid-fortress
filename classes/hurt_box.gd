class_name HurtBox extends Area2D

signal damage_taken(damage, knockback_force : Vector2, damage_dealer : Node2D)

func take_damage(damage : float, knockback_force : Vector2, damage_dealer : Node2D):
	damage_taken.emit(damage, knockback_force, damage_dealer)
