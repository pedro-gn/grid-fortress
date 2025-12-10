extends Projectile

@export var animation_player : AnimationPlayer

func _on_impact():
	animation_player.play("explosion")
	await animation_player.animation_finished
	queue_free.call_deferred()
	
func _on_hit_box_max_hits_reached():
	pass
