extends Control

var playScene : String = "res://Scenes/GameWorld.tscn"
var mainMenuScene : String = "res://Scenes/MainMenu.tscn"

onready var playerSlider = $PlayerSlider
onready var timeLimit = $TimeLimit

func _on_BackButton_pressed():
	Configs.button_play()
	# warning-ignore:return_value_discarded
	get_tree().change_scene(mainMenuScene)

func _on_PlayButton_pressed():
	Configs.playerArray.clear()
	
	for x in range(playerSlider.value):
		var playerConfig = $PlayerConfigArray.get_child(x)
		if playerConfig.humanCheck:
			Configs.playerArray.append("Human")
		else:
			Configs.playerArray.append("AI")
		Configs.playerSprites.append(playerConfig.spriteArray[playerConfig.spriteId-1])
		Configs.playerNames.append($PlayerConfigArray.get_child(x).playerName)
		Configs.gameTime = timeLimit.value
	
	# warning-ignore:return_value_discarded
	get_tree().change_scene(playScene)

func _process(_delta):
	var count = 1
	for player in $PlayerConfigArray.get_children():
		if count <= playerSlider.value:
			player.visible = true
		else:
			player.visible = false
		count += 1
