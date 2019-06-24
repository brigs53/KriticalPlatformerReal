extends Area2D

#making variable for first layer, switch layer on attacks
#hitbox has to be on a different layer when disabled to properly work
onready var startLayer := collision_layer
onready var startMask := collision_mask
#just using := infers type, copies right side type
var disabled := true
export var damage := 1
#onready var shapes := []

func _ready():
	disable()
#	for child in get_children():
#		if child is CollisionShape2D:
#			shapes.append(child)
	#Connects signal via code
	#print("Connected")
	if not is_connected("body_entered", self, "hitLanded"):
		connect("body_entered", self, "hitLanded")

func toggleDisabled():
	disabled = !disabled
	if disabled:
		#corresponds to the disabled layer in binary
		collision_layer = 32
		collision_mask = 0
	else:
		collision_layer = startLayer
		collision_mask = startMask
		
func enable():
	disabled = false
	#print("Enabled")
	collision_layer = startLayer
	collision_mask = startMask
	
func disable():
	disabled = true
	collision_layer = 32
	collision_mask = 0
	
func hitLanded(body: PhysicsBody2D):
	print("Hit")
	if body.has_method("takeDamage"):
		body.takeDamage(damage)
