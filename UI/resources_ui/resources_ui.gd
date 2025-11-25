extends Control
class_name ResourcesUI

@export var gold_label : RichTextLabel

func _on_gold_changed(qnt : int) -> void:
	gold_label.text = str(qnt)
