@tool
@icon("res://addons/sensetree/behavior_tree/icon/Action.svg")
class_name SenseTreeGoToWaypointAction
extends SenseTreeActionLeaf

#Entity goes to a specific waypoint

## Navigation agent to update and modify.
@export var navigation_agent: NavigationAgent2D
## Marker2D to set destination
@export var waypoint: Marker2D
## Agent navigation speed.
@export var max_speed: float = 50
## Distance between agent position and investigation point within which investigation area is considered 'reached'.
@export_range(10, 500) var desired_distance: float = 30

var _has_destination: bool = false


func _get_configuration_warnings() -> PackedStringArray:
	var configuration_warnings = super._get_configuration_warnings()
	if not navigation_agent:
		configuration_warnings.push_back("Navigation agent should be set.")
	if not waypoint:
		configuration_warnings.push_back("Waypoint should be set.")
	return configuration_warnings


func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	if _has_destination and navigation_agent.is_navigation_finished():
		return Status.SUCCESS
	if navigation_agent.target_position != waypoint.global_position:
		navigation_agent.target_position = waypoint.global_position
		_has_destination = true
	if not navigation_agent.is_target_reachable():
		return Status.FAILURE
	else:
		return Status.RUNNING

func get_sensenode_class() -> String:
	return "SenseTreeGoToWaypointAction"


func get_exported_properties() -> Array[SenseTreeExportedProperty]:
	var navigation_agent_property = SenseTreeExportedProperty.new(
		"navigation_agent", "Navigation Agent", navigation_agent.name
	)
	var waypoint_property = SenseTreeExportedProperty.new("waypoint", "Waypoint", waypoint)
	var max_speed_property = SenseTreeExportedProperty.new("max_speed", "Max Speed", max_speed)
	var desired_distance_property = SenseTreeExportedProperty.new(
		"desired_distance", "Desired Distance", desired_distance
	)
	return [
		navigation_agent_property,
		waypoint_property,
		max_speed_property,
		desired_distance_property,
	]
