extends Area2D

export var speed : float = 300

func _process(delta):
	translate(Vector2(speed*delta, 0))

func _on_Fireball_body_entered(body: PhysicsBody2D):
	queue_free()