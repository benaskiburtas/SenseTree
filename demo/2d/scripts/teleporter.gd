extends Area2D

func _on_body_entered(body):
	if body.name == "Player":
		body.global_position = $Entry.global_position
