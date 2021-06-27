extends Control

export var keybindEdit : PackedScene
export(Array) var spriteArray

onready var playerId = int(name.right(13))
onready var playerName = "player" + str(playerId)
onready var sprite = $Control/SpritePanel/Sprite

var spriteId = 1

var joystickCheck = 0
var humanCheck = true

func _ready():
	$TextEdit.text = playerName.capitalize()
	spriteId = playerId
	sprite_change()
	if Configs.keybindType[playerName] == 1:
		$CheckBox.pressed = true
	
func _process(_delta):
	$CheckBox.visible = $CheckButton.pressed 
#	$KeybindsButton.visible = $CheckButton.pressed 
#
#	if $CheckBox.pressed:
#		joystickCheck = 1
#	else:
#		joystickCheck = 0
	
func _on_TextEdit_text_changed(new_text):
	playerName = new_text

func _on_KeybindsButton_pressed():
	var newPopup = keybindEdit.instance()
	newPopup.playerName = playerName
	newPopup.device = joystickCheck
	get_parent().get_parent().add_child(newPopup)

func _on_Minus_pressed():
	if spriteId != 1:
		spriteId -= 1
	sprite_change()
	
func _on_Plus_pressed():
	if spriteId != (spriteArray.size()):
		spriteId += 1
	sprite_change()
	
func sprite_change():
	$Control/SpriteCount/SpriteCountLabel.text = str(spriteId)
	sprite.texture = spriteArray[spriteId-1]
