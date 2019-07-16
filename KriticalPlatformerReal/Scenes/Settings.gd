extends Control

func _ready():
	$"HBoxContainer/VBoxContainer/Master Volume".text = "Master Volume: 0%"
func _on_HSlider_value_changed(value):
	$"HBoxContainer/VBoxContainer/Master Volume".text = "Master Volume: " + str(value) + "%"