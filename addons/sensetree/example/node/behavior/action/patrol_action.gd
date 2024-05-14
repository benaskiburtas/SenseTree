@tool
@icon("res://addons/sensetree/example/icon/Patrol_Area.svg")
class_name SenseTreePatrolAction
extends SenseTreeActionLeaf

#Entity moves between two points, watching out for threats until interrupted (sees threat/unfulfilled needs)

## Navigation agent to update and modify.
@export var navigation_agent: NavigationAgent2D
## Marker2D to set patrol points
@export var waypoint_a: Marker2D
@export var waypoint_b: Marker2D
## Agent navigation speed.
@export var max_speed: float = 65
## Distance between agent position and investigation point within which investigation area is considered 'reached'.
@export_range(10, 500) var desired_distance: float = 30

var _has_destination: bool = false


func _get_configuration_warnings() -> PackedStringArray:
	var configuration_warnings = super._get_configuration_warnings()
	if not navigation_agent:
		configuration_warnings.push_back("Navigation agent should be set.")
	if not waypoint_a:
		configuration_warnings.push_back("First waypoint should be set.")
	if not waypoint_b:
		configuration_warnings.push_back("Second waypoint should be set.")
	return configuration_warnings


func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	if not navigation_agent:
		_try_acquire_navigation_agent(actor)
	
	if _has_destination == true and navigation_agent.is_navigation_finished():
		_check_and_set_waypoint_destination()
		return Status.SUCCESS
	_check_and_set_waypoint_destination()
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
	var waypoint_a_property = SenseTreeExportedProperty.new("waypoint", "Waypoint A", waypoint_a)
	var waypoint_b_property = SenseTreeExportedProperty.new("waypoint", "Waypoint B", waypoint_b)
	var max_speed_property = SenseTreeExportedProperty.new("max_speed", "Max Speed", max_speed)
	var desired_distance_property = SenseTreeExportedProperty.new(
		"desired_distance", "Desired Distance", desired_distance
	)
	return [
		navigation_agent_property,
		waypoint_a_property,
		waypoint_b_property,
		max_speed_property,
		desired_distance_property,
	]


func _try_acquire_navigation_agent(actor: Node) -> void:
	var found_agent = actor.find_child("NavigationAgent2D")
	if not found_agent or not found_agent is NavigationAgent2D:
		return
	else:
		navigation_agent = found_agent


func _check_and_set_waypoint_destination() -> void:
	if (
		navigation_agent.target_position != waypoint_a.global_position
		and navigation_agent.target_position != waypoint_b.global_position
	):
		navigation_agent.target_position = waypoint_a.global_position
		_has_destination = true

	if (
		navigation_agent.target_position == waypoint_a.global_position
		and navigation_agent.is_navigation_finished()
	):
		navigation_agent.target_position = waypoint_b.global_position

	if (
		navigation_agent.target_position == waypoint_b.global_position
		and navigation_agent.is_navigation_finished()
	):
		navigation_agent.target_position = waypoint_a.global_position
		
	navigation_agent.max_speed = max_speed
