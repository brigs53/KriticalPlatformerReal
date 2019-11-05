extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	var bodies= get_overlapping_bodies()
	for body in bodies:
		if body.name=="Player":
			get_tree().reload_current_scene()