class_name HurtBox extends Area2D

signal damage_taken(damage : Damage, damage_dealer : Node2D)



func take_damage(damage_data: Damage,  damage_dealer : Node2D):
	damage_taken.emit(damage_data, damage_dealer)
