@tool
@icon("res://addons/sensetree/behavior_tree/icon/Action.svg")
class_name SenseTreeRoamAreaAction
extends SenseTreeActionLeaf

##stuff to do
##assign marker somewhere in the code(???)

## Navigation agent to update and modify.
@export var navigation_agent: NavigationAgent2D
## Marker2D to set roaming point
@export var roaming_point: Marker2D
## Agent investigation navigation speed.
@export var max_speed: float = 45
## Radius of a circular area to roam in.
@export_range(0, 1000) var roaming_radius: float = 100
## Distance between agent position and investigation point within which investigation area is considered 'reached'.
@export_range(10, 500) var desired_distance: float = 30
## Allowed distance from travel points while navigating
@export_range(0, 10000) var max_path_deviance: float = 100

## Path color when navigation agent is set to 'debug' mode.
@export var debug_path_custom_color: Color = Color.ORANGE
## Path line width when navigation agent is set to 'debug' mode.
@export var debug_path_custom_line_width: float = 2
## Path waypoint size when navigation agent is set to 'debug' mode.
@export var debug_path_custom_point_size: float = 4

var _has_roaming_target: bool = false


func _init():
	randomize()


func _get_configuration_warnings() -> PackedStringArray:
	var configuration_warnings = super._get_configuration_warnings()
	if not roaming_point:
		configuration_warnings.push_back("Roaming point should be set.")
	if not navigation_agent:
		configuration_warnings.push_back("Navigation agent should be set.")
	if not max_speed:
		configuration_warnings.push_back("Maximum navigation speed should be set.")
	return configuration_warnings


func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	if not navigation_agent:
		return Status.FAILURE

	if navigation_agent.debug_enabled:
		_set_debug_properties()
	_update_navigation_agent_properties()

	if not _has_roaming_target or not navigation_agent.is_target_reachable():
		navigation_agent.target_position = _generate_roaming_point(actor)
		_has_roaming_target = true

	if not navigation_agent.is_navigation_finished:
		_has_roaming_target = false
		return Status.RUNNING

	if navigation_agent.is_navigation_finished():
		_has_roaming_target = false
		return Status.SUCCESS

	return Status.RUNNING


func get_sensenode_class() -> String:
	return "SenseTreeInvestigateAreaAction2D"


func get_exported_properties() -> Array[SenseTreeExportedProperty]:
	var navigation_agent_property = SenseTreeExportedProperty.new(
		"navigation_agent",
		"Navigation Agent",
		navigation_agent.name if navigation_agent else "[None]"
	)
	var roaming_point_property = SenseTreeExportedProperty.new(
		"roaming_point", "Roaming Point", roaming_point.name if roaming_point else "[None]"
	)
	var max_speed_property = SenseTreeExportedProperty.new("max_speed", "Max Speed", max_speed)
	var roaming_radius_property = SenseTreeExportedProperty.new(
		"roaming_radius", "Roaming Radius", roaming_radius
	)
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
		roaming_point_property,
		max_speed_property,
		roaming_radius_property,
		desired_distance_property,
		max_path_deviance_property,
		debug_path_custom_color_property,
		debug_path_custom_line_width_property,
		debug_path_custom_point_size_property
	]


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


func _generate_roaming_point(actor: Node) -> Vector2:
	var random_angle = deg_to_rad(randi_range(-180, 180))
	var new_point_distance = randf_range(1, self.roaming_radius)

	var new_point_x = new_point_distance * cos(random_angle)
	var new_point_y = new_point_distance * sin(random_angle)

	var roam_origin = roaming_point.global_position

	return Vector2(roam_origin.x + new_point_x, roam_origin.y + new_point_y)
