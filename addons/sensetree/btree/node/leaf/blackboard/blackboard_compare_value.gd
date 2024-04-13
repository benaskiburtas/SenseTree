@tool
class_name SenseTreeBlackboardCompareValueAction
extends SenseTreeActionLeaf

enum ComparisonOperator {
	LESS_THAN, LESS_THAN_OR_EQUALS, EQUALS, NOT_EQUALS, GREATER_THAN_OR_EQUALS, GREATER_THAN
}

@export_placeholder("Blackboard key") var blackboard_key: String
@export_placeholder("Comparison value") var comparison_value: String
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
	var blackboard_value: Variant = blackboard.get_value(blackboard_key)

	if blackboard_value == null or comparison_value == null:
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
			return Status.SUCCESS if blackboard_value < comparison_value else Status.FAILURE
		_:
			return Status.FAILURE
