@tool
@icon("res://addons/sensetree/example/icon/Investigate_Area.svg")
class_name SenseTreeInvestigateAreaAction2D
extends SenseTreeActionLeaf

## Navigation agent to update and modify.
@export var navigation_agent: NavigationAgent2D
## Agent investigation navigation speed.
@export var max_speed: float = 70
## Radius of a circular area to search in.
@export_range(0, 1000) var investigation_radius: float = 100
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

var _has_investigation_target: bool = false


func _init():
	randomize()


func _get_configuration_warnings() -> PackedStringArray:
	var configuration_warnings = super._get_configuration_warnings()
	if not navigation_agent:
		configuration_warnings.push_back("Navigation agent should be set.")
	if not max_speed:
		configuration_warnings.push_back("Maximum navigation speed should be set.")
	return configuration_warnings


func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	if not navigation_agent:
		_try_acquire_navigation_agent(actor)
		
	if not navigation_agent:
		return Status.FAILURE

	if navigation_agent.debug_enabled:
		_set_debug_properties()
	_update_navigation_agent_properties()

	if not _has_investigation_target or not navigation_agent.is_target_reachable():
		navigation_agent.target_position = _generate_investigation_point(actor)
		navigation_agent.max_speed = max_speed
		_has_investigation_target = true

	if not navigation_agent.is_navigation_finished:
		_has_investigation_target = false
		return Status.RUNNING

	if navigation_agent.is_navigation_finished():
		_has_investigation_target = false
		return Status.SUCCESS

	return Status.RUNNING


func get_sensenode_class() -> String:
	return "SenseTreeInvestigateAreaAction2D"


func get_exported_properties() -> Array[SenseTreeExportedProperty]:
	var navigation_agent_property = SenseTreeExportedProperty.new(
		"navigation_agent", "Navigation Agent", navigation_agent.name
	)
	var max_speed_property = SenseTreeExportedProperty.new("max_speed", "Max Speed", max_speed)
	var investigation_radius_property = SenseTreeExportedProperty.new(
		"investigation_radius", "Investigation Radius", investigation_radius
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
		max_speed_property,
		investigation_radius_property,
		desired_distance_property,
		max_path_deviance_property,
		debug_path_custom_color_property,
		debug_path_custom_line_width_property,
		debug_path_custom_point_size_property
	]


func _try_acquire_navigation_agent(actor: Node) -> void:
	var found_agent = actor.find_child("NavigationAgent2D")
	if not found_agent or not found_agent is NavigationAgent2D:
		return
	else:
		navigation_agent = found_agent


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


func _generate_investigation_point(actor: Node) -> Vector2:
	var random_angle = deg_to_rad(randi_range(-180, 180))
	var new_point_distance = randf_range(1, self.investigation_radius)

	var new_point_x = new_point_distance * cos(random_angle)
	var new_point_y = new_point_distance * sin(random_angle)

	var actor_position = actor.get_global_position()

	return Vector2(actor_position.x + new_point_x, actor_position.y + new_point_y)
