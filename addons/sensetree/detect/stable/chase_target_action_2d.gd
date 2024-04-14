@tool
class_name ChaseTargetAction2D
extends SenseTreeActionLeaf

## Navigation agent to update and modify.
@export var navigation_agent: NavigationAgent2D
## Target that will be navigated to and chased.
@export var chase_target: Node2D
## Agent chase navigation speed.
@export var max_speed: float
## Distance between target position and chase target within which target is considered 'reached'.
@export_range(10, 500) var desired_distance: float = 20
## Allowed distance from travel points while navigating
@export_range(0, 10000) var max_path_deviance: float = 100

## Path color when navigation agent is set to 'debug' mode.
@export var debug_path_custom_color: Color = Color.DARK_RED
## Path line width when navigation agent is set to 'debug' mode.
@export var debug_path_custom_line_width: float = 3
## Path waypoint size when navigation agent is set to 'debug' mode.
@export var debug_path_custom_point_size: float = 6


func _get_configuration_warnings() -> PackedStringArray:
	var configuration_warnings = super._get_configuration_warnings()
	if not navigation_agent:
		configuration_warnings.push_back("Navigation agent should be set.")
	if not chase_target:
		configuration_warnings.push_back("Chase target should be set.")
	if not max_speed:
		configuration_warnings.push_back("Maximum navigation speed should be set.")
	return configuration_warnings


func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	if not chase_target:
		return Status.SUCCESS
	if not navigation_agent:
		return Status.FAILURE

	if navigation_agent.debug_enabled:
		_set_debug_properties()

	_update_navigation_agent_properties()
	_adjust_navigation_goal()

	if not navigation_agent.is_target_reachable():
		return Status.FAILURE

	if not navigation_agent.is_navigation_finished:
		return Status.RUNNING

	if navigation_agent.is_target_reached():
		return Status.SUCCESS
	return Status.RUNNING


func _set_debug_properties() -> void:
	navigation_agent.debug_path_custom_color = self.debug_path_custom_color
	navigation_agent.debug_path_custom_line_width = self.debug_path_custom_line_width
	navigation_agent.debug_path_custom_point_size = self.debug_path_custom_point_size


func _update_navigation_agent_properties() -> void:
	if not navigation_agent.target_desired_distance == self.desired_distance:
		navigation_agent.target_desired_distance = self.desired_distance
	if not navigation_agent.max_speed == self.max_speed:
		navigation_agent.max_speed = self.max_speed
	if not navigation_agent.path_max_distance == self.max_path_deviance:
		navigation_agent.path_max_distance = self.max_path_deviance


func _adjust_navigation_goal() -> void:
	var chase_target_position = chase_target.global_position
	var final_position = navigation_agent.get_final_position()
	var destination_discrepancy = final_position.distance_to(chase_target_position)
	if destination_discrepancy > desired_distance:
		navigation_agent.target_position = chase_target_position
