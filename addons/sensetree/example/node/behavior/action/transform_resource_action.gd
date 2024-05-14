@tool
@icon("res://addons/sensetree/example/icon/Transform_Resource.svg")
class_name SenseTreeTransformResourceAction
extends SenseTreeActionLeaf

#Entity converts one resource into another (cooking raw food into meals)
#(Possibly harvesting raw meat from (wildlife) corpses?)

@export var input_resource_key: String
@export var output_resource_key: String

var _decrement_resource: SenseTreeBlackboardModifyValueAction
var _increment_resource: SenseTreeBlackboardModifyValueAction

func _init() -> void:
	_decrement_resource = SenseTreeBlackboardModifyValueAction.new()
	_increment_resource = SenseTreeBlackboardModifyValueAction.new()

func _ready() -> void:
	_decrement_resource.blackboard_key = input_resource_key
	_decrement_resource.modification_value = "1"
	_decrement_resource.modification_operator = SenseTreeBlackboardModifyValueAction.ModificationOperator.SUBTRACT

	_increment_resource.blackboard_key = output_resource_key
	_increment_resource.modification_value = "1"
	_increment_resource.modification_operator = SenseTreeBlackboardModifyValueAction.ModificationOperator.ADD

func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	var input_resource_transformed = _decrement_resource.tick(actor, blackboard)
	if input_resource_transformed == Status.SUCCESS:
		var output_resource_transformed = _increment_resource.tick(actor, blackboard)
		if output_resource_transformed == Status.SUCCESS:
			return Status.SUCCESS
	return Status.FAILURE

func get_sensenode_class() -> String:
	return "SenseTreeTransformResourceAction"

func get_exported_properties() -> Array[SenseTreeExportedProperty]:
	var input_resource_key_property = SenseTreeExportedProperty.new(
		"input_resource_key_property", "Input Resource Key", input_resource_key
	)
	var output_resource_key_property = SenseTreeExportedProperty.new(
		"output_resource_key_property", "Output Resource Key", output_resource_key
	)
	return [
		input_resource_key_property,
		output_resource_key_property,
	]
