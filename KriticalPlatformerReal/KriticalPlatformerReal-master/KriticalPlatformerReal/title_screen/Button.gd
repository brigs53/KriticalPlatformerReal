extends Node2D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(delta):
	if Input.is_action_just_pressed("Left Mouse") or Input.is_action_just_pressed("Enter"):
		$ButtonSFX.play()
