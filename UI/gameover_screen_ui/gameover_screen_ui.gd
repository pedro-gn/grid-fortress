extends Control
class_name GameOverScreenUI

@export var play_again_button : Button
@export var exit_button : Button

func _ready() -> void:
	play_again_button.pressed.connect(_on_play_again_button_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)

func _on_play_again_button_pressed():
	GameManager.load_scene(GameManager.SCENES.MAIN)
	
func _on_exit_button_pressed():
	get_tree().quit()
