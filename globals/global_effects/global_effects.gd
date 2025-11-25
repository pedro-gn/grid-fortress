extends Node


var gold_earn_effect : PackedScene = preload("res://globals/global_effects/gold_earn_effect/gold_earn_effect.tscn")

enum EFFECTS {
	GOLD_EARN,
}

func spawn_effect(position : Vector2, effect : EFFECTS, value : int = 0):
	if effect == EFFECTS.GOLD_EARN:
		print("SPAWNING GOLD EFFECT")
		var gold_earn_effect_instance : GoldEarnEffect = gold_earn_effect.instantiate()
		add_child(gold_earn_effect_instance)
		gold_earn_effect_instance.global_position = position
		gold_earn_effect_instance.start(value)
	
