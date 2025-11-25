extends Control
class_name GoldEarnEffect

@export var animation_player : AnimationPlayer
@export var label : RichTextLabel

func start(gold_qnt : int):
	animation_player.play("main")
	label.text = "+" + str(gold_qnt)
