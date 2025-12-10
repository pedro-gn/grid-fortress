extends Projectile

@export var damage_per_pixel := 0.05 

func post_setup():
	var distance = tower_global_position.distance_to(target_pos)
	hit_box.damage_data.physical_damage += (damage_per_pixel * distance)
