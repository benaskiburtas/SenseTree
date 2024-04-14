@tool
class_name SenseTreeBlackboardClearKeyAction
extends SenseTreeActionLeaf

@export_placeholder("Blackboard key") var blackboard_key: String

func _get_configuration_warnings() -> PackedStringArray:
	var configuration_warnings: PackedStringArray = super._get_configuration_warnings()
	if not blackboard_key or blackboard_key.is_empty():
		configuration_warnings.push_back("Blackboard key for erasure should be set.")
	return configuration_warnings

func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	blackboard.clear_value(blackboard_key)
	return Status.SUCCESS