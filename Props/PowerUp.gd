extends Node2D


func _on_Area2D_body_entered(body):
	if body is Player:
		if body.growth == false:
			body.grow()
			$AnimationPlayer.queue_free()
			$Transform.queue_free()
			$SFX.play()

func _on_SFX_finished():
	queue_free()
