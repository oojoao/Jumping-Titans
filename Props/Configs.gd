extends Node

var playerArray : Array
var playerNames : Array
var playerSprites : Array
var configFile : ConfigFile
var configFilePath = "res://keybinds.ini"
var buttonSFX = preload("res://Props/ButtonSFX.tscn")

var gameTime = 120.0
var keybinds = {}
var keybindType = {}

func _ready():
	configFile = ConfigFile.new()
	if configFile.load(configFilePath) == OK:
		for key in configFile.get_section_keys("keybinds"):
			var key_value = configFile.get_value("keybinds", key)
			
			if str(key_value) != "":
				keybinds[key] = key_value
			else:
				keybinds[key] = null
			
		for key in configFile.get_section_keys("device"):
			var key_value = configFile.get_value("device", key)
			
			keybindType[key] = key_value
	
	set_binds()
	
func set_binds():
	var deviceCount = 0
	var playerName = ""
	
	for key in keybindType.keys():
		var value = keybindType[key]
		
		if value == 1:
			playerName = key
			break
	
	for key in keybinds.keys():
		var value = keybinds[key]
		
		var actionList = InputMap.get_action_list(key)
		if !actionList.empty():
			InputMap.action_erase_event(key, actionList[0])
			
		if value != null:
			var new_key
			if keybindType[key.left(7)] == 0:
				new_key = InputEventKey.new()
				new_key.set_scancode(value)
			elif keybindType[key.left(7)] == 1:
				if playerName != key.left(7):
					deviceCount +=1
					playerName = key.left(7)
				new_key = InputEventJoypadButton.new()
				new_key.device = deviceCount
				new_key.set_button_index(value)
			InputMap.action_add_event(key, new_key)
		

func write_config():
	for key in keybinds.keys():
		var key_value = keybinds[key]
		if key_value != null:
			configFile.set_value("keybinds", key, key_value)
		else:
			configFile.set_value("keybinds", key, "")
	
	# warning-ignore:return_value_discarded
	configFile.save(configFilePath)

func button_play():
	var button = buttonSFX.instance()
	get_tree().get_root().add_child(button)
	button.play()
	yield(button, "finished")
	button.queue_free()
