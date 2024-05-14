@tool
@icon("res://addons/sensetree/example/icon/Collect_Resource.svg")
class_name SenseTreeTakeResourceAction
extends SenseTreeBlackboardModifyValueAction

@export var storage_targets: Array[StorageNode] = []

const INCREMENT_RESOURCE_VALUE_OPERATOR = ModificationOperator.ADD
const INCREMENT_VALUE: String = "1"


func _init() -> void:
	self.modification_value = INCREMENT_VALUE
	self.modification_operator = INCREMENT_RESOURCE_VALUE_OPERATOR


func _get_configuration_warnings() -> PackedStringArray:
	var configuration_warnings: PackedStringArray = []
	if not storage_targets or storage_targets.is_empty():
		configuration_warnings.push_back("Resource storages should be set.")
	return configuration_warnings


func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	var is_any_take_success: bool = false
	for storage in storage_targets:
		if storage.is_empty():
			continue
		else:
			var is_take_sucess = storage.take_resource()
			if is_take_sucess:
				print("Took from %s" % storage.name)
				is_any_take_success = true
				super.tick(actor, blackboard)
	return Status.SUCCESS if is_any_take_success else Status.FAILURE


func get_sensenode_class() -> String:
	return "SenseTreeCollectResourceAction"


func get_exported_properties() -> Array[SenseTreeExportedProperty]:
	var blackboard_key_property = SenseTreeExportedProperty.new(
		"blackboard_key", "Blackboard key", blackboard_key
	)
	var harvest_targets_property = SenseTreeExportedProperty.new(
		"storage_targets", "Storage Targets Count", storage_targets.size()
	)
	return [blackboard_key_property, harvest_targets_property]


func _validate_property(property: Dictionary) -> void:
	if property.name in ["modification_value", "modification_operator"]:
		property.usage = PROPERTY_USAGE_NO_EDITOR
