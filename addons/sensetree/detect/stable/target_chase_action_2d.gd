@tool
@icon("res://addons/sensetree/btree/icon/Action.svg")
class_name SenseTreeTargetChaseAction2D
extends SenseTreeActionLeaf

const MAX_FLOAT = 1.79769e308

## Navigation agent to update and modify.
@export var navigation_agent: NavigationAgent2D
## Group whose closest member will be navigated to and chased.
@export var chase_group: String
## Agent chase navigation speed.
@export var max_speed: float = 65
## Distance between target position and chase target within which target is considered 'reached'.
@export_range(10, 500) var desired_distance: float = 30
## Allowed distance from travel points while navigating
@export_range(0, 10000) var max_path_deviance: float = 100

## Path color when navigation agent is set to 'debug' mode.
@export var debug_path_custom_color: Color = Color.DARK_RED
## Path line width when navigation agent is set to 'debug' mode.
@export var debug_path_custom_line_width: float = 3
## Path waypoint size when navigation agent is set to 'debug' mode.
@export var debug_path_custom_point_size: float = 6

var _has_chase_target: bool = false


func _get_configuration_warnings() -> PackedStringArray:
	var configuration_warnings = super._get_configuration_warnings()
	if not navigation_agent:
		configuration_warnings.push_back("Navigation agent should be set.")
	if not chase_group:
		configuration_warnings.push_back("Chase group should be set.")
	return configuration_warnings


func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	if not chase_group:
		return Status.SUCCESS
	if not navigation_agent:
		return Status.FAILURE

	if navigation_agent.debug_enabled:
		_set_debug_properties()

	_update_navigation_agent_properties()

	var group_members = get_tree().get_nodes_in_group(chase_group)
	if group_members.is_empty():
		return Status.FAILURE
	_adjust_navigation_goal(actor, group_members)

	if not navigation_agent.is_target_reachable():
		return Status.FAILURE

	if not navigation_agent.is_navigation_finished:
		return Status.RUNNING

	if navigation_agent.is_target_reached():
		return Status.SUCCESS
	return Status.RUNNING


func get_sensenode_class() -> String:
	return "SenseTreeTargetChaseAction2D"


func get_exported_properties() -> Array[SenseTreeExportedProperty]:
	var navigation_agent_property = SenseTreeExportedProperty.new(
		"navigation_agent", "Navigation Agent", navigation_agent.name
	)
	var chase_group_property = SenseTreeExportedProperty.new(
		"chase_group", "Chase Group", chase_group
	)
	var max_speed_property = SenseTreeExportedProperty.new("max_speed", "Max Speed", max_speed)
	var desired_distance_property = SenseTreeExportedProperty.new(
		"desired_distance", "Desired Distance", desired_distance
	)
	var max_path_deviance_property = SenseTreeExportedProperty.new(
		"max_path_deviance", "Max Path Deviance", max_path_deviance
	)
	var debug_path_custom_color_property = SenseTreeExportedProperty.new(
		"debug_path_custom_color", "Debug Path Custom Color", debug_path_custom_color
	)
	var debug_path_custom_line_width_property = SenseTreeExportedProperty.new(
		"debug_path_custom_line_width", "Debug Path Custom Line Width", debug_path_custom_line_width
	)
	var debug_path_custom_point_size_property = SenseTreeExportedProperty.new(
		"debug_path_custom_point_size", "Debug Path Custom Point Size", debug_path_custom_point_size
	)
	return [
		navigation_agent_property,
		chase_group_property,
		max_speed_property,
		desired_distance_property,
		max_path_deviance_property,
		debug_path_custom_color_property,
		debug_path_custom_line_width_property,
		debug_path_custom_point_size_property
	]


func _set_debug_properties() -> void:
	navigation_agent.debug_use_custom = true
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


func _adjust_navigation_goal(actor: Node2D, chase_group_members: Array[Node]) -> void:
	var closest_node: Node2D
	var smallest_distance: float = MAX_FLOAT

	for member in chase_group_members:
		var actor_position: Vector2 = actor.global_position
		var member_position: Vector2 = member.global_position
		var distance: float = actor_position.distance_to(member_position)
		if smallest_distance == null or distance < smallest_distance:
			smallest_distance = distance
			closest_node = member

	var chase_target_position = closest_node.global_position
	var final_position = navigation_agent.get_final_position()
	var destination_discrepancy = final_position.distance_to(chase_target_position)
	if destination_discrepancy > desired_distance:
		navigation_agent.target_position = chase_target_position
