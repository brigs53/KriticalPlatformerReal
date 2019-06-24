extends Area2D

#making variable for first layer, switch layer on attacks
#hitbox has to be on a different layer when disabled to properly work
onready var startLayer := collision_layer
onready var startMask := collision_mask
#just using := infers type, copies right side type
var disabled := true
export var damage := 1

func _ready():
	disable()

func toggleDisabled():
	disabled = !disabled
	if disabled:
		#corresponds to the player layer in binary
		collision_layer = 32
		collision_mask = 0
	else:
		collision_layer = startLayer
		collision_mask = startMask
		
func enable():
	disabled = false
	collision_layer = startLayer
	collision_mask = startMask
	
func disable():
	disabled = true
	collision_layer = 32
	collision_mask = 0
	
	
func _on_playerHitbox_body_entered(body):
	body.takeDamage(damage)
