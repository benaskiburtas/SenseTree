extends CharacterBody2D

@export var speed = 150

func get_input():
	var input_direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = input_direction * speed

func _physics_process(_delta):
	get_input()
	move_and_slide()

@onready var _animated_sprite = $AnimatedSprite2D

func _process(_delta):
	if Input.is_action_pressed("Left"):
		_animated_sprite.play("Left")
	elif Input.is_action_pressed("Right") or Input.is_action_pressed("Down") or Input.is_action_pressed("Up"):
		_animated_sprite.play("Right")
	else:
		_animated_sprite.play("Idle")
