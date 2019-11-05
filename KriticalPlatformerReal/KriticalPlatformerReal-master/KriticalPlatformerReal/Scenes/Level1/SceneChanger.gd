extends Area2D

# warning-ignore:unused_argument
func _physics_process(delta):
	var bodies= get_overlapping_bodies()
	for body in bodies:
		if body.name=="Player":
# warning-ignore:return_value_discarded
			get_tree().change_scene("res://Scenes/LevelSelect/LevelBackdrop.tscn")
			pass