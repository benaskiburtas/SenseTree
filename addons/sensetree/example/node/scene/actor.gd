class_name Actor
extends CharacterBody2D

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D


func _ready() -> void:
	navigation_agent.velocity_computed.connect(_on_velocity_computed)


func set_movement_target(movement_target: Vector2):
	navigation_agent.set_target_position(movement_target)


func _physics_process(_delta):
	if navigation_agent.is_navigation_finished():
		return

	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	var new_velocity: Vector2 = (
		global_position.direction_to(next_path_position).normalized() * navigation_agent.max_speed
	)
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)


func _on_velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity
	print("actor %s" % name)
	print(safe_velocity)
	move_and_slide()
