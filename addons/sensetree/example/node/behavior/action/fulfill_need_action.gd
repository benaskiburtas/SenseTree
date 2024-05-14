@tool
@icon("res://addons/sensetree/example/icon/Fulfill_Needs.svg")
class_name SenseTreeFulfillNeedAction
extends SenseTreeActionLeaf

@export var need_fulfillment_resource_key: String
@export var need_key: String
@export_range(0, 100) var need_decrement_value: int

var _decrement_resource: SenseTreeBlackboardModifyValueAction
var _decrement_need: SenseTreeBlackboardModifyValueAction


func _init() -> void:
	_decrement_resource = SenseTreeBlackboardModifyValueAction.new()
	_decrement_need = SenseTreeBlackboardModifyValueAction.new()


func _ready() -> void:
	_decrement_resource.blackboard_key = need_fulfillment_resource_key
	_decrement_resource.modification_value = "1"
	_decrement_resource.modification_operator = (
		SenseTreeBlackboardModifyValueAction.ModificationOperator.SUBTRACT
	)

	_decrement_need.blackboard_key = need_fulfillment_resource_key
	_decrement_need.modification_value = str(need_decrement_value)
	_decrement_need.modification_operator = (
		SenseTreeBlackboardModifyValueAction.ModificationOperator.SUBTRACT
	)


func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	if not blackboard.has_key(need_key):
		return Status.SUCCESS
	if not blackboard.has_key(need_fulfillment_resource_key):
		return Status.FAILURE

	var current_need_level = float(blackboard.get_value(need_key))
	var clamped_decrement_need_value: float = 0
	if current_need_level + need_decrement_value > 100:
		clamped_decrement_need_value = 100 - current_need_level
	else:
		clamped_decrement_need_value = need_decrement_value

	var has_consumed_resource = _decrement_resource.tick(actor, blackboard)
	if has_consumed_resource == Status.SUCCESS:
		_decrement_need.modification_value = str(clamped_decrement_need_value)
		var has_fulfilled_need = _decrement_need.tick(actor, blackboard)
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
	var need_decrement_value_property = SenseTreeExportedProperty.new(
		"need_decrement_value", "Need Decrement Value", need_decrement_value
	)
	return [
		need_fulfillment_resource_key_property, need_key_property, need_decrement_value_property
	]
