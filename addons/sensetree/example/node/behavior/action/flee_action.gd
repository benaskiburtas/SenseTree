@tool
@icon("res://addons/sensetree/example/icon/Flee.svg")
class_name SenseTreeFleeAction
extends SenseTreeActionLeaf

## Navigation agent to update and modify.
@export var navigation_agent: NavigationAgent2D
## Agent navigation speed.
@export var max_speed: float = 200
## Distance between actor position and fleeing point within which the target flee area is considered 'reached'.
@export_range(10, 500) var desired_distance: float = 30
@export var flee_distance: float = 50
## Path color when navigation agent is set to 'debug' mode.
@export var debug_path_custom_color: Color = Color.ORANGE
## Path line width when navigation agent is set to 'debug' mode.
@export var debug_path_custom_line_width: float = 2
## Path waypoint size when navigation agent is set to 'debug' mode.
@export var debug_path_custom_point_size: float = 4

var _has_destination: bool = false


func _get_configuration_warnings() -> PackedStringArray:
	var configuration_warnings = super._get_configuration_warnings()
	if not navigation_agent:
		configuration_warnings.push_back("Navigation agent should be set.")
	return configuration_warnings


func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	if not navigation_agent:
		_try_acquire_navigation_agent(actor)

	if not navigation_agent:
		return Status.FAILURE

	# If there is no threat, no fleeing is needed
	if not blackboard.has_key(SenseTreeConstants.THREAT_TARGET_KEY):
		return Status.SUCCESS
	var target = blackboard.get_value(SenseTreeConstants.THREAT_TARGET_KEY)
	if not target:
		return Status.SUCCESS

	if navigation_agent.debug_enabled:
		_set_debug_properties()

	if not _has_destination or not navigation_agent.is_target_reachable():
		navigation_agent.target_position = _calculate_fleeing_point(actor, target)
		navigation_agent.max_speed = max_speed
		_has_destination = true

	if not navigation_agent.is_navigation_finished:
		_has_destination = false
		return Status.RUNNING

	if navigation_agent.is_navigation_finished():
		_has_destination = false
		return Status.SUCCESS

	return Status.RUNNING


func _try_acquire_navigation_agent(actor: Node) -> void:
	var found_agent = actor.find_child("NavigationAgent2D")
	if not found_agent or not found_agent is NavigationAgent2D:
		return
	else:
		navigation_agent = found_agent


func _calculate_fleeing_point(actor: Node, target: Node) -> Vector2:
	var actor_position = actor.get_global_position()
	var target_position = target.get_global_position()
	var flee_direction = (actor.global_position.direction_to(target_position) * -1).normalized()
	return actor_position + flee_direction * flee_distance


func _set_debug_properties() -> void:
	navigation_agent.debug_path_custom_color = self.debug_path_custom_color
	navigation_agent.debug_path_custom_line_width = self.debug_path_custom_line_width
	navigation_agent.debug_path_custom_point_size = self.debug_path_custom_point_size


func get_sensenode_class() -> String:
	return "SenseTreeFleeAction"


func get_exported_properties() -> Array[SenseTreeExportedProperty]:
	var navigation_agent_property = SenseTreeExportedProperty.new(
		"navigation_agent", "Navigation Agent", navigation_agent.name
	)
	var max_speed_property = SenseTreeExportedProperty.new("max_speed", "Max Speed", max_speed)
	var desired_distance_property = SenseTreeExportedProperty.new(
		"desired_distance", "Desired distance", desired_distance
	)
	var flee_distance_property = SenseTreeExportedProperty.new(
		"flee_distance", "Flee Distance", flee_distance
	)
	return [
		navigation_agent_property,
		max_speed_property,
		desired_distance_property,
		flee_distance_property
	]
