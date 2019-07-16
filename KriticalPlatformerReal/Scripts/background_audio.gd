extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var music = AudioStreamPlayer.new()
	add_child(music)
	var stream = load("res://Music/Background Music/C418 - Biome Fest (Minecraft Volume Beta).ogg")
	music.set_stream(stream)
	music.volume_db = 1
	music.pitch_scale = 1
	music.play()