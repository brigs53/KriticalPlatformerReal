extends Node2D
#levelstuff
export (int) var level
export (String) var level_to_load
export (bool) var enabled

#texture stuff
export (Texture) var blocked_texture
export (Texture) var open_texture
export (Texture) var goal_met

onready var level_label =$TextureButton/Label
onready var button=$ TextureButton

func _ready():
	pass # Replace with function body.
func setup():
	level_label.text= String (level)
	if enabled:
		button.texture_normal = open_texture
	else:
		button.texture_normal= blocked_texture
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):  
#	pass


func _on_TextureButton_pressed():
	if enabled:
		get_tree().change_scene(level_to_load)
	
