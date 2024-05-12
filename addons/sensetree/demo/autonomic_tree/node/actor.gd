extends CharacterBody2D

const ANIM_IDLE_LEFT = "idle_left"
const ANIM_IDLE_RIGHT = "idle_right"
const ANIM_IDLE_UP = "idle_up"
const ANIM_IDLE_DOWN = "idle_down"

const ANIM_MOVE_LEFT = "move_left"
const ANIM_MOVE_RIGHT = "move_right"
const ANIM_MOVE_UP = "move_up"
const ANIM_MOVE_DOWN = "move_down"

@export var movement_speed: float = 200
@export var movement_acceleration: float = 1.5
@export var wander_radius: float = 300
@export var min_direction_change_time: float = 0.25
@export var max_direction_change_time: float = 2.0

var _animated_sprite: AnimatedSprite2D = $CollisionShape2D/AnimatedSprite2D
var _navigation_agent: NavigationAgent2D = $NavigationAgent2D
var _navigation_timer = Timer.new()
var _current_direction = Vector2.ZERO


func _ready():
	_navigation_agent.max_speed = movement_speed
	_initialize_timer()

	_generate_investigation_point()


func _physics_process(delta: float) -> void:
	var next_position = _navigation_agent.get_next_path_position() - self.global_position
	var direction = next_position.normalized()

	velocity = velocity.lerp(direction * movement_speed, movement_acceleration * delta)
	_play_sprite_by_direction()
	move_and_slide()


func _initialize_timer() -> void:
	_navigation_timer.connect("timeout", _on_navigation_timer_timeout)
	add_child(_navigation_timer)
	_navigation_timer.start()


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


func _on_navigation_timer_timeout():
	if not _navigation_agent.is_target_reachable() or _navigation_agent.is_navigation_finished():
		_navigation_agent.target_position = _generate_investigation_point()


func _generate_investigation_point() -> Vector2:
	var random_angle = deg_to_rad(randi_range(-180, 180))
	var new_point_distance = randf_range(1, wander_radius)

	var new_point_x = new_point_distance * cos(random_angle)
	var new_point_y = new_point_distance * sin(random_angle)

	var actor_position = self.get_global_position()

	return Vector2(actor_position.x + new_point_x, actor_position.y + new_point_y)
