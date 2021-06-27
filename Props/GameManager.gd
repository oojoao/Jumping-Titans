extends Node

var inputsMenu = "res://Scenes/InputsMenu.tscn"

onready var startTimer = $StartTimer
onready var powerupTimer = $PowerUpTimer
onready var powerupLocationsArray = get_node("../PowerUpLocations")
onready var playerSpawnArray = get_node("../PlayerSpawn")
onready var playerYSort = get_node("../PlayerYSort")

export var humanPlayer : PackedScene
export var powerup : PackedScene
export var countdown : PackedScene
var currentPowerup
var playerArray : Array
var gameStart = false
var gameStartCount = 3
var gameTime
var powerupRespawn = 15.0

func _ready():
	gameTime = Configs.gameTime
	playerArray = Configs.playerArray
	
	var playerCount = 0
	var locations = playerSpawnArray.get_children()
	var playerLocationArray = range(locations.size())
	
	for type in playerArray:
		var currentPlayer
		if type == "Human":
			currentPlayer = humanPlayer.instance()
		currentPlayer.playerID = playerCount + 1
		currentPlayer.name = Configs.playerNames[playerCount]
		
		playerYSort.add_child(currentPlayer)
		
		randomize()
		var local = randi() % playerLocationArray.size()
		currentPlayer.global_position = locations[playerLocationArray[local]].global_position
		if locations[playerLocationArray[local]].global_position.x > (OS.get_screen_size().x / 2):
			currentPlayer.sprite.flip_h = true
		playerLocationArray.remove(local)

		playerCount += 1
	
	add_child(countdown.instance())
	$Countdown.rect_position = Vector2.ZERO

func _process(_delta):
	if !is_instance_valid(currentPowerup) && powerupTimer.time_left == 0:
		powerupTimer.start(powerupRespawn)

func _on_PowerUpTimer_timeout():
	var locations = powerupLocationsArray.get_children()
	currentPowerup = powerup.instance()
	add_child(currentPowerup)
	randomize()
	currentPowerup.global_position = locations[randi() % locations.size()].global_position


func _on_StartTimer_timeout():
	if !gameStart:
		if gameStartCount != 0:
			$Countdown/Label.text = str(gameStartCount)
			$Countdown/AnimationPlayer.play("Fading")
			gameStartCount -= 1
			$CountdownSFX.play()
			startTimer.start(1.0)
		else:
			$Countdown/Label.text = "GO!"
			$CountdownSFX.pitch_scale *= 1.5
			$CountdownSFX.play()
			$Music.play()
			$Countdown/AnimationPlayer.play("Fading")
			gameStart = true
			for player in playerYSort.get_children():
				player.gameStart = true
			startTimer.start(gameTime)
			get_node("../Label").text = str(int(ceil(startTimer.time_left)))
			get_node("../Label").visible = true
			yield(get_tree().create_timer(1.0), "timeout")
			$CountdownSFX.pitch_scale /= 1.5
			$Countdown/Label.text = ""
	else:
		if is_instance_valid(currentPowerup):
			currentPowerup.queue_free()
		
		var players = playerYSort.get_children()
		var winner = players.front()
		var tie = false
		gameStart = false
		
		for player in players:
			if player != winner && player.points == winner.points:
				tie = true
			elif player.points > winner.points:
				winner = player
				tie = false
				
			player.gameStart = false
		
		$Music.stop()
		$WinSFX.play()
		
		if tie:
			for player in players:
				print(player.points)
			$Countdown/Label.text = "Its a tie!"
		else:
			$Countdown/Label.text = winner.name + " WINS!"
		$Countdown/AnimationPlayer.play("BackAndForth")
		startTimer.queue_free()
		yield(get_tree().create_timer(5.0), "timeout")
		# warning-ignore:return_value_discarded
		get_tree().change_scene(inputsMenu)

func _on_Timer_timeout():
	if gameStart:
		var gameTimeCount = int(floor(startTimer.time_left))
		get_node("../Label").text = str(gameTimeCount)
		if gameTimeCount <= 10:
			get_node("../Label").modulate = Color(1.0,0.2,0.2,1.0)
