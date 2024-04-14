extends Node2D

func _process(_delta):
	if Input.is_action_pressed("Return"):
		$Player/Player.global_position = $"Main Lobby".global_position
