@tool
@icon("res://addons/sensetree/behavior_tree/icon/Blackboard_Compare_Value.svg")
class_name SenseTreeBlackboardCompareValueCondition
extends SenseTreeConditionLeaf

enum ComparisonOperator {
	LESS_THAN, LESS_THAN_OR_EQUALS, EQUALS, NOT_EQUALS, GREATER_THAN_OR_EQUALS, GREATER_THAN
}

@export_placeholder("Blackboard key") var blackboard_key: String
@export_placeholder("Comparison value") var comparison_value: Variant
@export var comparison_operator: ComparisonOperator


func _get_configuration_warnings() -> PackedStringArray:
	var configuration_warnings: PackedStringArray = super._get_configuration_warnings()
	if not blackboard_key or blackboard_key.is_empty():
		configuration_warnings.push_back("Blackboard key for comparison should be set.")
	if not comparison_value or comparison_value.is_empty():
		configuration_warnings.push_back("Value for comparison should be set.")
	if not comparison_operator:
		configuration_warnings.push_back("Comparison operator should be selected.")
	return configuration_warnings


func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	if not blackboard.has_key(blackboard_key):
		return Status.FAILURE

	var blackboard_value: Variant = blackboard.get_value(blackboard_key)

	if blackboard_value == null or comparison_value == null:
		return Status.FAILURE

	if _validate_and_parse_expression(blackboard_value) != OK:
		return Status.FAILURE

	match comparison_operator:
		ComparisonOperator.LESS_THAN:
			return Status.SUCCESS if blackboard_value < comparison_value else Status.FAILURE
		ComparisonOperator.LESS_THAN_OR_EQUALS:
			return Status.SUCCESS if blackboard_value <= comparison_value else Status.FAILURE
		ComparisonOperator.EQUALS:
			return Status.SUCCESS if blackboard_value == comparison_value else Status.FAILURE
		ComparisonOperator.NOT_EQUALS:
			return Status.SUCCESS if blackboard_value != comparison_value else Status.FAILURE
		ComparisonOperator.GREATER_THAN_OR_EQUALS:
			return Status.SUCCESS if blackboard_value >= comparison_value else Status.FAILURE
		ComparisonOperator.GREATER_THAN:
			return Status.SUCCESS if blackboard_value > comparison_value else Status.FAILURE
		_:
			return Status.FAILURE


func get_sensenode_class() -> String:
	return "SenseTreeBlackboardCompareValueAction"


func get_exported_properties() -> Array[SenseTreeExportedProperty]:
	var blackboard_key_property = SenseTreeExportedProperty.new(
		"blackboard_key", "Blackboard key", blackboard_key
	)
	var comparison_value_property = SenseTreeExportedProperty.new(
		"comparison_value", "Comparison value", comparison_value
	)
	var comparison_operator_property = SenseTreeExportedProperty.new(
		"comparison_operator", "Comparison Operator", ComparisonOperator.keys()[comparison_operator]
	)
	return [blackboard_key_property, comparison_value_property, comparison_operator_property]


func _validate_and_parse_expression(blackboard_value: Variant) -> Error:
	push_warning("Incompatible types for blackboard value comparison.")
	if _is_number(blackboard_value) and _is_number(comparison_value):
		return OK
	if _is_string(blackboard_value) and _is_string(comparison_value):
		return OK
	else:
		return ERR_INVALID_PARAMETER


func _is_number(input: Variant) -> bool:
	return true if typeof(input) == TYPE_INT or typeof(input) == TYPE_FLOAT else false


func _is_string(input: Variant) -> bool:
	return typeof(input) == TYPE_STRING
