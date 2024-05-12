@tool
@icon("res://addons/sensetree/behavior_tree/icon/Action.svg")
class_name SenseTreePlaceResourceAction
extends SenseTreeBlackboardModifyValueAction

@export var storage_locations: Array[StorageNode] = []

const DECREMENT_RESOURCE_VALUE_OPERATOR = ModificationOperator.SUBTRACT
const DECREMENT_VALUE: String = "1"

func _init() -> void:
	self.modification_value = DECREMENT_VALUE
	self.modification_operator = DECREMENT_RESOURCE_VALUE_OPERATOR

func _get_configuration_warnings() -> PackedStringArray:
	var configuration_warnings: PackedStringArray = []
	if not storage_locations or storage_locations.is_empty():
		configuration_warnings.push_back("Storage locations should be set.")
	return configuration_warnings

func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	for storage in storage_locations:
		if not storage.has_free_space():
			continue
		else:
			var is_place_success = storage.store_resource()
			if is_place_success:
				super.tick(actor, blackboard)
				return Status.SUCCESS
	return Status.FAILURE

func get_sensenode_class() -> String:
	return "SenseTreePlaceResourceAction"

func get_exported_properties() -> Array[SenseTreeExportedProperty]:
	var blackboard_key_property = SenseTreeExportedProperty.new(
		"blackboard_key", "Blackboard key", blackboard_key
	)
	var storage_locations_property = SenseTreeExportedProperty.new(
		"storage_location", "Storage Location Count", storage_locations.size()
	)
	return [blackboard_key_property, storage_locations_property]

func _validate_property(property: Dictionary) -> void:
	if property.name in ["modification_value", "modification_operator"]:
		property.usage = PROPERTY_USAGE_NO_EDITOR
