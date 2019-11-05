extends KinematicBody2D
class_name Character

#utility junk
const Utils = preload("res://Scripts/Character_Utils.gd")

#health
export var maxHealth := 3
onready var currentHealth := maxHealth

#movement
export var runSpeed : float = 80
var velocity = Vector2()
export var jumpHeight : float = 40
export var jumpTime : float = 0.25


#Child nodes
onready var animP : AnimationPlayer = $AnimationPlayer
onready var sprite : Sprite = $Sprite

var dead := false

signal death
signal take_damage


func takeDamage(damage : int, knockback : Vector2 = Vector2.ZERO):
	currentHealth -= damage
	emit_signal("take_damage", damage)
	if(currentHealth <= 0):
		dead = true
		emit_signal("death")
		#$AnimationPlayer.play("onDeath")