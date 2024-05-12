@tool
@icon("res://addons/sensetree/behavior_tree/icon/Action.svg")
class_name SenseTreeCollectResourceAction
extends SenseTreeBlackboardModifyValueAction

@export var harvest_targets: Array[HarvestableNode] = []

const INCREMENT_RESOURCE_VALUE_OPERATOR = ModificationOperator.ADD
const INCREMENT_VALUE: String = "1"


func _init() -> void:
	self.modification_value = INCREMENT_VALUE
	self.modification_operator = INCREMENT_RESOURCE_VALUE_OPERATOR


func _get_configuration_warnings() -> PackedStringArray:
	var configuration_warnings: PackedStringArray = []
	if not harvest_targets or harvest_targets.is_empty():
		configuration_warnings.push_back("Harvest targets should be set.")
	return configuration_warnings


func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	var is_any_harvest_success: bool = false
	for resource in harvest_targets:
		if not resource.is_ready_for_harvest():
			continue
		else:
			var is_harvest_success = resource.harvest_resource()
			if is_harvest_success:
				is_any_harvest_success = true
				super.tick(actor, blackboard)
	return Status.SUCCESS if is_any_harvest_success else Status.FAILURE


func get_sensenode_class() -> String:
	return "SenseTreeCollectResourceAction"


func get_exported_properties() -> Array[SenseTreeExportedProperty]:
	var blackboard_key_property = SenseTreeExportedProperty.new(
		"blackboard_key", "Blackboard key", blackboard_key
	)
	var harvest_targets_property = SenseTreeExportedProperty.new(
		"harvest_targets", "Harvest Target Count", harvest_targets.size()
	)
	return [blackboard_key_property, harvest_targets_property]


func _validate_property(property: Dictionary) -> void:
	if property.name in ["modification_value", "modification_operator"]:
		property.usage = PROPERTY_USAGE_NO_EDITOR
