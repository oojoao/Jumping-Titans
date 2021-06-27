extends Control

onready var buttonContainer = $Panel/VBoxContainer
export var keyButton : Script

var keybinds
var playerName
var device
var deviceChanged = false

var buttons = {}

func _ready():
	keybinds = Configs.keybinds.duplicate()
	
	for key in keybinds.keys():
		if key.left(7) != playerName:
			keybinds.erase(key)
	
	if Configs.keybindType[playerName] != device:
		deviceChanged = true
		
	for key in keybinds.keys():
		var hbox = HBoxContainer.new()
		var label = Label.new()
		var button = Button.new()
		
		for x in [hbox, label, button]:
			x.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		
		label.text = key.right(8).capitalize()
		
		var button_value = keybinds[key]
		
		if deviceChanged:
			button_value = null
		
		if button_value == null:
			button.text = "Unassigned"
		elif Configs.keybindType[key.left(7)] == 0:
			button.text = OS.get_scancode_string(button_value)
		elif Configs.keybindType[key.left(7)] == 1:
			button.text = str(button_value)
		
		button.set_script(keyButton)
		button.key = key
		button.value = button_value
		button.menu = self
		button.toggle_mode = true
		button.focus_mode = Control.FOCUS_NONE
		
		
		hbox.add_child(label)
		hbox.add_child(button)
		buttonContainer.add_child(hbox)
		
		buttons[key] = button

func change_bind(key, value):
	keybinds[key] = value
	for k in keybinds.keys():
		if k != key && value != null && keybinds[k] == value:
			keybinds[k] = null
			buttons[k].value = null
			buttons[k].text = "Unassigned"

func _on_Back_pressed():
	queue_free()
	
func _on_Save_pressed():
	for key in keybinds.keys():
		var key_value = keybinds[key]
		Configs.keybinds[key] = key_value
		
	if deviceChanged:
		Configs.keybindType[playerName] = device
		
	Configs.set_binds()
	Configs.write_config()
	queue_free()
