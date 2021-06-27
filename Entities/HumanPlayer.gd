class_name HumanPlayer
extends Player

func jump_request():
	if gameStart:
		return Input.is_action_just_pressed("player" + str(playerID) + "_jump") 

func jump_down_request():
	if gameStart:
		return Input.is_action_pressed("player" + str(playerID) + "_down")
	
func _physics_process(_delta):
	# Direction as Input
	if gameStart:
		direction = Input.get_action_strength("player" + str(playerID) + "_right") - Input.get_action_strength("player" + str(playerID) + "_left")

