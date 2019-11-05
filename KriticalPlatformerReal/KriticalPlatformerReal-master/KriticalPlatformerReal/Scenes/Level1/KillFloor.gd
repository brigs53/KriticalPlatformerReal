extends Area2D
export (String) var level_to_load
func _physics_process(delta):
	var bodies= get_overlapping_bodies()
	for body in bodies:
		if body.name=="Player":
			get_tree().reload_current_scene()