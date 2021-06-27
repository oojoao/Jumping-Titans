extends Navigation2D

export var pathPoint : PackedScene

func create_path(character, objective):
	var new_path = get_simple_path(character.global_position, objective.global_position)
	character.path = new_path
	$Line2D.points = new_path
	for point in new_path:
		var newPathPoint = pathPoint.instance()
		add_child(newPathPoint)
		newPathPoint.global_position = point
		newPathPoint.playerRequested = character.playerID
