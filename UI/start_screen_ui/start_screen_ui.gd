extends Control
class_name StartScreenUI

@export var start_button : Button
@export var exit_button : Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_button.pressed.connect(_on_start_button_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)

func _on_start_button_pressed():
	GameManager.load_scene(GameManager.SCENES.MAIN)

func _on_exit_button_pressed():
	pass
