class_name Player
extends KinematicBody2D

const GRAVITY = 800.0
const WALK_SPEED = 200
const JUMP_FORCE = 250.0

onready var sprite = $Sprite
onready var raycastArray = $RayCastArray
onready var gameManager = get_node("../../GameManager")
onready var gameStart = gameManager.gameStart setget initialState
onready var animationPlayer = $AnimationTree.get("parameters/playback")

export var playerID = 1
var points = 0
var growth = false
var jumping = false
var dropped = false
var direction = 0.0
var velocity = Vector2()
var playerName setget change_name

func _ready():
	sprite.texture = Configs.playerSprites[playerID-1]
	$Label.text = name
	$Label.visible = true

func initialState(value):
	gameStart = value
	yield(get_tree().create_timer(2.5), "timeout")
	$Label.visible = false

func change_name(value):
	playerName = value
	name = playerName

func test_one_way():
	var isOneWayTest = false
	for raycast in raycastArray.get_children():
		if raycast.is_colliding() && raycast.get_collider() is TileMap:
			var collidingTile = raycast.get_collider()
			var collidingTilePos = collidingTile.world_to_map(global_position)
			if growth:
				collidingTilePos += Vector2.DOWN
			collidingTilePos -= raycast.get_collision_normal()
			var collidingTileId = collidingTile.get_cellv(collidingTilePos)
			if collidingTileId != -1:
				isOneWayTest = collidingTile.tile_set.tile_get_shape_one_way(collidingTileId, 0)
		if isOneWayTest:
			break
	return isOneWayTest

func is_grounded():
	if dropped:
		return false
		
	for raycast in raycastArray.get_children():
		if raycast.is_colliding():
			return true
	
	return false

func grow():
	if growth == false:
		global_position.y -= 16 * scale.y
		scale *= 2
		growth = true
		
		yield(get_tree().create_timer(10.0), "timeout")
		if is_instance_valid(self):
			scale /= 2
			global_position.y += 16 * scale.y
			growth = false

func _on_FeetCollision_area_entered(area):
	if area.name == "HeadCollision" && area.get_parent() != self && area.get_parent().is_in_group("player"):
		if growth && !is_on_floor():
			points += 1
			velocity.y = -JUMP_FORCE
			area.get_parent().global_position.y += 1000
			
			if dropped:
				dropped = false
				set_collision_mask_bit(0, true)
			
			$AudioStreamPlayer2D.play()
			
			yield(get_tree().create_timer(3.0), "timeout")
			
			area.get_parent().velocity.y = 0
			
			randomize()
			
			var locations = gameManager.playerSpawnArray.get_children()
			area.get_parent().global_position = locations[randi() % locations.size()].global_position
	
func _on_HeadCollision_body_entered(body):
	if dropped && body is TileMap:
		dropped = false
		set_collision_mask_bit(0, true)

func jump_request():
	pass

func jump_down_request():
	pass

func test():
	var previousGlobalPosition = global_position
	var floorCollidingArray = []
	for x in $PlayerCollisionArea.get_overlapping_bodies():
		if x is TileMap:
			floorCollidingArray.append(x)
	yield(get_tree().create_timer(0.02),"timeout")
	if global_position == previousGlobalPosition && animationPlayer.get_current_node() == "Jump":
		global_position.y += 4 * (floorCollidingArray.size())
		for x in floorCollidingArray:
			var velSignal = 1
			if velocity.x < 0:
				velSignal = -1
			velocity.x += x.global_position.direction_to(global_position).x * velSignal

func _physics_process(delta):
#	print(global_position.y)
	
	var floorCollidingArray = []
	for x in $PlayerCollisionArea.get_overlapping_bodies():
		if x is TileMap:
			floorCollidingArray.append(x)
		else:
			velocity.x = (x.global_position.direction_to(global_position).x) * WALK_SPEED /2
	if !floorCollidingArray.empty():
		test()
		
	# If is on the floor
	if is_on_floor():
		velocity.y = delta * GRAVITY
		
		# Check if is requesting jump
		if jump_request() && gameStart:
			
			# Check if is requesting to jump down
			if jump_down_request() && test_one_way():
				set_collision_mask_bit(0, false)
				dropped = true
			
			# If it didnt request do jump down or is impossible to, then jump normally
			else:
				velocity.y = -JUMP_FORCE
			
	# If is jumping
	else:
		# Vertical velocity
		if velocity.y >= (GRAVITY / 2):
			velocity.y = GRAVITY / 2
		else:
			velocity.y += delta * GRAVITY
		
		
	# Animation
	if is_on_floor():
		if velocity.x != 0:
			animationPlayer.travel("Run")
			sprite.flip_h = velocity.x < 0
		else:
			animationPlayer.travel("Idle")
	else:
		if velocity.x != 0:
			sprite.flip_h = velocity.x < 0
		animationPlayer.travel("Jump")
	
	
	# Horizontal velocity
	velocity.x = WALK_SPEED * direction
	if growth:
		velocity.x += WALK_SPEED * direction / 3
	
	# Movement
	velocity = move_and_slide(velocity, Vector2.UP)
	
	global_position.x = clamp(global_position.x, 0, OS.get_screen_size().x)
	global_position.y = clamp(global_position.y, -200, OS.get_screen_size().y-52)
