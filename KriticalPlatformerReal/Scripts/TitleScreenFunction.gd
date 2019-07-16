extends Control

func _ready():
	$Menu/CenterRow/Buttons/NewGameButton2.connect("pressed",self,"NewGame")
	$Menu/CenterRow/Buttons/ContinueButton2.connect("pressed",self,"Continue")
	$Menu/CenterRow/Buttons/OptionsButton2.connect("pressed",self,"Options")
	$Menu/CenterRow/Buttons/QuitButton2.connect("pressed",self,"Quit")
	pass
	
func NewGame():
	get_tree().change_scene("res://Scenes/Level1/TutorialLevel.tscn")

func Continue():
	get_tree().change_scene("res://Scenes/Level1/TutorialLevel.tscn")

func Options():
	get_tree().change_scene("res://Scenes/TitleScreen/game/Options.tscn")

func Quit():
	get_tree().quit()
