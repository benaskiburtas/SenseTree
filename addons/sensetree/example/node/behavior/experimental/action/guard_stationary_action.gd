@tool
@icon("res://addons/sensetree/behavior_tree/icon/Action.svg")
class_name SenseTreeGuardStationaryAction
extends SenseTreeActionLeaf

#Entity stays in one place and watches for threats until interrupted (sees threat/unfilfilled need)
## Duration in milliseconds
@export var stand_guard_duration: int = 8000

var _time_passed: int

func _get_configuration_warnings() -> PackedStringArray:
	var configuration_warnings = super._get_configuration_warnings()
	if not stand_guard_duration:
		configuration_warnings.push_back("Duration should be set.")
	return configuration_warnings

func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	_time_passed = Time.get_ticks_msec()
	if _time_passed >= stand_guard_duration:
		return Status.SUCCESS
	else:
		return Status.RUNNING

func get_sensenode_class() -> String:
	return "SenseTreeGuardStationaryAction"

func get_exported_properties() -> Array[SenseTreeExportedProperty]:
	var guard_duration_property = SenseTreeExportedProperty.new(
		"guard_duration", "Stand Guard Duration", stand_guard_duration
	)
	return [
		guard_duration_property
	]
