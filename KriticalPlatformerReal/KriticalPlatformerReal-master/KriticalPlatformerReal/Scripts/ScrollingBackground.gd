extends Sprite

export var scrollSpeed := Vector2(200, 0)
export var parallaxFactor := Vector2(1, 1)
export var isParallax := false

var totalScroll = Vector2()

var camera : Camera2D

func _ready():
	region_enabled = true
	camera = get_tree().get_nodes_in_group("Camera")[0] as Camera2D

func _process(delta):
	if isParallax:
		totalScroll += scrollSpeed * delta
		region_rect.position = totalScroll + camera.get_camera_screen_center()*parallaxFactor
	else:
		region_rect.position += scrollSpeed * delta
	