extends Control
class_name WavesUI

@export var timer_label : RichTextLabel
@export var wave_label : RichTextLabel



func _ready():
	timer_label.visible = false
	wave_label.text = "WAVE 0/0"
	

func connect_signals():
	pass

func _on_wave_changed(current: int, total: int):
	wave_label.text = "WAVE %d / %d" % [current, total]

func _on_wave_started():
	timer_label.visible = false

func _on_timer_updated(time_left: int):
	if time_left > 0:
		timer_label.visible = true
		timer_label.text = "NEXT IN: %ds" % time_left
		
		# Optional: Make it turn red when close to 0
		if time_left <= 3:
			timer_label.modulate = Color.RED
		else:
			timer_label.modulate = Color.WHITE
	else:
		timer_label.visible = false

func _on_all_completed():
	timer_label.visible = false
	wave_label.text = "VICTORY"
	wave_label.modulate = Color.GREEN
