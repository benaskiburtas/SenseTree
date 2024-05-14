class_name Actor
extends CharacterBody2D

const ANIM_IDLE_LEFT = "idle_left"
const ANIM_IDLE_RIGHT = "idle_right"
const ANIM_IDLE_UP = "idle_up"
const ANIM_IDLE_DOWN = "idle_down"

const ANIM_MOVE_LEFT = "move_left"
const ANIM_MOVE_RIGHT = "move_right"
const ANIM_MOVE_UP = "move_up"
const ANIM_MOVE_DOWN = "move_down"

@onready var _animated_sprite: AnimatedSprite2D = $CollisionShape2D/AnimatedSprite2D
@onready var _navigation_agent: NavigationAgent2D = $NavigationAgent2D
var _current_direction = Vector2.ZERO


func _ready() -> void:
	_navigation_agent.velocity_computed.connect(_on_velocity_computed)


func set_movement_target(movement_target: Vector2):
	_navigation_agent.set_target_position(movement_target)


func _physics_process(_delta):
	if _navigation_agent.is_navigation_finished():
		return

	var next_path_position: Vector2 = _navigation_agent.get_next_path_position()
	var new_velocity: Vector2 = (
		global_position.direction_to(next_path_position).normalized() * (_navigation_agent.max_speed * 1.4)
	)
	if _navigation_agent.avoidance_enabled:
		_navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)


func _play_sprite_by_direction() -> void:
	var normalized_velocity = velocity.normalized()
	if abs(normalized_velocity.x) > abs(normalized_velocity.y):
		if normalized_velocity.x < 0:
			_animated_sprite.play(ANIM_MOVE_LEFT)
		else:
			_animated_sprite.play(ANIM_MOVE_RIGHT)
	else:
		if normalized_velocity.y < 0:
			_animated_sprite.play(ANIM_MOVE_UP)
		else:
			_animated_sprite.play(ANIM_MOVE_DOWN)

	if velocity.length() == 0:
		if abs(_current_direction.x) > abs(_current_direction.y):
			if _current_direction.x < 0:
				_animated_sprite.play(ANIM_IDLE_LEFT)
			else:
				_animated_sprite.play(ANIM_IDLE_RIGHT)
		else:
			if _current_direction.y < 0:
				_animated_sprite.play(ANIM_IDLE_UP)
			else:
				_animated_sprite.play(ANIM_IDLE_DOWN)


func _on_velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity
	_play_sprite_by_direction()
	move_and_slide()
