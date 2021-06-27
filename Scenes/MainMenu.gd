extends Control

var playScene : String = "res://Scenes/InputsMenu.tscn"
var creditsScene : String = "res://Scenes/Credits.tscn"
var tutorialScene : String = "res://Scenes/Tutorial.tscn"
var buttonSFX : PackedScene

func _on_PlayButton_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene(playScene)
	Configs.button_play()
	
func _on_TutorialButton_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene(tutorialScene)
	Configs.button_play()
	
func _on_CreditsButton_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene(creditsScene)
	Configs.button_play()
	
func _on_QuitButton_pressed():
	get_tree().quit()
