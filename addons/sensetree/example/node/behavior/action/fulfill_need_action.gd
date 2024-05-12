@tool
@icon("res://addons/sensetree/behavior_tree/icon/Action.svg")
class_name SenseTreeFulfillNeedAction
extends SenseTreeActionLeaf

@export var need_fulfillment_resource_key: String
@export var need_key: String
@export_range(0, 100) var need_increment_value: int

var _decrement_resource: SenseTreeBlackboardModifyValueAction
var _fulfill_need: SenseTreeBlackboardModifyValueAction


func _init() -> void:
	_decrement_resource = SenseTreeBlackboardModifyValueAction.new()
	_fulfill_need = SenseTreeBlackboardModifyValueAction.new()


func _ready() -> void:
	_decrement_resource.blackboard_key = need_fulfillment_resource_key
	_decrement_resource.modification_value = "1"
	_decrement_resource.modification_operator = (
		SenseTreeBlackboardModifyValueAction.ModificationOperator.SUBTRACT
	)

	_fulfill_need.blackboard_key = need_fulfillment_resource_key
	_fulfill_need.modification_value = str(need_increment_value)
	_fulfill_need.modification_operator = (
		SenseTreeBlackboardModifyValueAction.ModificationOperator.ADD
	)


func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	var has_consumed_resource = _decrement_resource.tick(actor, blackboard)
	if has_consumed_resource == Status.SUCCESS:
		var has_fulfilled_need = _fulfill_need.tick(actor, blackboard)
		if has_fulfilled_need == Status.SUCCESS:
			return Status.SUCCESS
	return Status.FAILURE


func get_sensenode_class() -> String:
	return "SenseTreeFulFillNeedsAction"


func get_exported_properties() -> Array[SenseTreeExportedProperty]:
	var need_fulfillment_resource_key_property = SenseTreeExportedProperty.new(
		"need_fulfillment_resource_key_property",
		"Need Fulfillment Resource Key",
		need_fulfillment_resource_key
	)
	var need_key_property = SenseTreeExportedProperty.new("need_key", "Need Key", need_key)
	var need_increment_value_property = SenseTreeExportedProperty.new(
		"need_increment_value", "Need Increment Value", need_increment_value
	)
	return [
		need_fulfillment_resource_key_property, need_key_property, need_increment_value_property
	]
