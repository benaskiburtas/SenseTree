@tool
@icon("res://addons/sensetree/behavior_tree/icon/Blackboard_Has_Key.svg")
class_name SenseTreeBlackboardHasKeyAction
extends SenseTreeActionLeaf

@export_placeholder("Blackboard key") var blackboard_key: String


func _get_configuration_warnings() -> PackedStringArray:
	var configuration_warnings: PackedStringArray = super._get_configuration_warnings()
	if not blackboard_key or blackboard_key.is_empty():
		configuration_warnings.push_back("Blackboard key for check should be set.")
	return configuration_warnings


func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	if blackboard.has_key(blackboard_key):
		return Status.SUCCESS
	else:
		return Status.FAILURE


func get_sensenode_class() -> String:
	return "SenseTreeBlackboardHasKeyAction"


func get_exported_properties() -> Array[SenseTreeExportedProperty]:
	var blackboard_key_property = SenseTreeExportedProperty.new(
		"blackboard_key", "Blackboard key", blackboard_key
	)
	return [blackboard_key_property]
