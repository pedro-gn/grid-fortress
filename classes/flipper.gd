class_name FlipperComponent extends Node2D

enum FLIP_MODE {
	VELOCITY,
	MOUSE_POSITION,
}
@export var flip : bool = false
@export var flip_mode : FLIP_MODE
@export var velocity_rigid_body : CharacterBody2D
@export var enabled : bool = true

var x = 1

func face_right():
	scale.x = 1

func face_left():
	scale.x = -1

func _physics_process(delta):
	if not enabled:
		return
	if flip_mode == FLIP_MODE.MOUSE_POSITION:
		if get_global_mouse_position().x > global_position.x:
			scale.x = 1
		else:
			scale.x = -1
	else:
		if velocity_rigid_body.velocity.x > 0:
			scale.x = 1
		elif velocity_rigid_body.velocity.x < 0:
			scale.x = -1
		else:
			pass
