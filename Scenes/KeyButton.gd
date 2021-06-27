extends Button

var key
var value
var menu

var waitingInput = false

func _toggled(button_pressed):
	if button_pressed:
		waitingInput = true
		set_text("Press Any Key")

func _input(event):
	if waitingInput:
		if event is InputEventKey:
			if Configs.keybindType[menu.playerName] == 0:
				value = event.scancode
				text = OS.get_scancode_string(value)
				menu.change_bind(key, value)
				pressed = false
				waitingInput = false
		elif event is InputEventJoypadButton:
			if Configs.keybindType[menu.playerName] == 1:
				value = event.button_index
				text = str(value)
				menu.change_bind(key, value)
				pressed = false
				waitingInput = false
		elif event is InputEventMouseButton:
			if value == null:
				text = "Unassigned"
			elif Configs.keybindType[menu.playerName] == 0:
				text = OS.get_scancode_string(value)
			elif Configs.keybindType[menu.playerName] == 1:
				text = str(value)
			pressed = false
			waitingInput = false
