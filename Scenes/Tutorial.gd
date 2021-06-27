extends Control

var mainMenuScene : String = "res://Scenes/MainMenu.tscn"

func _on_TextureButton_pressed():
	Configs.button_play()
	# warning-ignore:return_value_discarded
	get_tree().change_scene(mainMenuScene)
