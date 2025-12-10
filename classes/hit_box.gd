class_name HitBox extends Area2D

signal max_hits_reached

@export var damage_data : Damage

@export var is_hit_limited : bool = false
@export var hit_quantity : int = 1

var _hit_counter : int = 0

func _ready():
	area_entered.connect(_on_area_entered)
	
func _on_area_entered(area : HurtBox):
	
	if is_hit_limited and  _hit_counter >= hit_quantity:
		return

	if area:
		area.take_damage(damage_data, self)
		if is_hit_limited:
			_hit_counter += 1

	if is_hit_limited and _hit_counter == hit_quantity:
		max_hits_reached.emit()
