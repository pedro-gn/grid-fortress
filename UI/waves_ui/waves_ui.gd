extends Control
class_name WavesUI

signal start_wave_button_pressed

@export var timer_label : RichTextLabel
@export var wave_label : RichTextLabel
@export var start_wave_button : Button
@export var wave_progress_bar : TextureProgressBar

# Variable to hold the active tween
var _progress_tween : Tween


func _ready():
	timer_label.visible = false
	wave_label.text = "Wave 0/0"
	
	# Initial setup (Instant, no tween needed here)
	wave_progress_bar.min_value = 0
	wave_progress_bar.max_value = 100
	wave_progress_bar.value = 100
	
	start_wave_button.pressed.connect(_on_start_wave_button_pressed)
	


func _on_start_wave_button_pressed():
	start_wave_button_pressed.emit()
	start_wave_button.text = "Skip Time"
	
func _on_wave_changed(current: int, total: int):
	wave_label.text = "WAVE %d / %d" % [current, total]

func _on_wave_started():
	timer_label.visible = false
	start_wave_button.visible = false
	start_wave_button.disabled = true

# --- NEW: Helper function to handle smooth animation ---
func _animate_bar_to(target_value: float):

	if _progress_tween:
		_progress_tween.kill()
	
	_progress_tween = create_tween()
	
	_progress_tween.tween_property(wave_progress_bar, "value", target_value, 0.3)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
# -------------------------------------------------------

func _on_wave_progress_updated(spawned_count: int, total_count: int):
	if total_count > 0:
		var percent_left = 1.0 - (float(spawned_count) / float(total_count))
		# Use the tween helper instead of setting .value directly
		_animate_bar_to(percent_left * 100)
	else:
		_animate_bar_to(0)

func _on_timer_updated(time_left: float, total_wait_time: float):
	if time_left > 0:
		start_wave_button.visible = true
		start_wave_button.disabled = false
		timer_label.visible = true
		
		timer_label.text = "NEXT IN: %ds" % ceil(time_left)
		
		# Calculate fill percentage (Filling up from 0 to 100)
		var percent_filled = (total_wait_time - time_left) / total_wait_time
		
		# Use the tween helper
		_animate_bar_to(percent_filled * 100)
		
		if time_left <= 3:
			timer_label.modulate = Color.RED
		else:
			timer_label.modulate = Color.WHITE
	else:
		timer_label.visible = false
		start_wave_button.visible = false
		# Ensure bar is visually full when timer ends (ready to drain for next wave)
		_animate_bar_to(100)

func _on_all_completed():
	timer_label.visible = false
	start_wave_button.visible = false
	wave_label.text = "VICTORY"
	wave_label.modulate = Color.GREEN
	_animate_bar_to(0)
