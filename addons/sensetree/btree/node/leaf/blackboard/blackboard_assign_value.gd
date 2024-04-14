@tool
@icon("res://addons/sensetree/btree/icon/Action.svg")
class_name SenseTreeBlackboardAssignValueAction
extends SenseTreeActionLeaf

@export_placeholder("Blackboard key") var blackboard_key: String
@export_placeholder("Key value") var key_value: String


func _get_configuration_warnings() -> PackedStringArray:
	var configuration_warnings: PackedStringArray = super._get_configuration_warnings()
	if not blackboard_key or blackboard_key.is_empty():
		configuration_warnings.push_back("Blackboard key for assignment should be set.")
	if not key_value:
		configuration_warnings.push_back("Key value for assignment should be set.")
	return configuration_warnings


func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	blackboard.set_value(blackboard_key, key_value)
	return Status.SUCCESS


func get_sensenode_class() -> String:
	return "SenseTreeBlackboardAssignValueAction"


func get_exported_properties() -> Array[SenseTreeExportedProperty]:
	var blackboard_key_property = SenseTreeExportedProperty.new()
	blackboard_key_property.property_name = "blackboard_key"
	blackboard_key_property.property_title = "Blackboard key"
	blackboard_key_property.value = blackboard_key

	var key_value_property = SenseTreeExportedProperty.new()
	key_value_property.property_name = "key_value"
	key_value_property.property_title = "Key value"
	key_value_property.value = key_value
	return [blackboard_key_property, key_value_property]
