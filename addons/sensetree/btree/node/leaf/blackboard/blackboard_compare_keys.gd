@tool
class_name SenseTreeBlackboardCompareKeysAction
extends SenseTreeActionLeaf

enum ComparisonOperator {
	LESS_THAN, LESS_THAN_OR_EQUALS, EQUALS, NOT_EQUALS, GREATER_THAN_OR_EQUALS, GREATER_THAN
}

@export_placeholder("First blackboard key") var first_blackboard_key: String
@export_placeholder("Second blackboard key") var second_blackboard_key: String
@export var comparison_operator: ComparisonOperator


func _get_configuration_warnings() -> PackedStringArray:
	var configuration_warnings: PackedStringArray = super._get_configuration_warnings()
	if not first_blackboard_key or first_blackboard_key.is_empty():
		configuration_warnings.push_back("First blackboard key for comparison should be set.")
	if not second_blackboard_key or second_blackboard_key.is_empty():
		configuration_warnings.push_back("Second blackboard key for comparison should be set.")
	if not comparison_operator:
		configuration_warnings.push_back("Comparison operator should be selected.")
	return configuration_warnings


func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	var first_key_value: Variant = blackboard.get_value(first_blackboard_key)
	var second_key_value: Variant = blackboard.get_value(second_blackboard_key)

	if first_key_value == null or second_key_value == null:
		return Status.FAILURE

	match comparison_operator:
		ComparisonOperator.LESS_THAN:
			return Status.SUCCESS if first_key_value < second_key_value else Status.FAILURE
		ComparisonOperator.LESS_THAN_OR_EQUALS:
			return Status.SUCCESS if first_key_value <= second_key_value else Status.FAILURE
		ComparisonOperator.EQUALS:
			return Status.SUCCESS if first_key_value == second_key_value else Status.FAILURE
		ComparisonOperator.NOT_EQUALS:
			return Status.SUCCESS if first_key_value != second_key_value else Status.FAILURE
		ComparisonOperator.GREATER_THAN_OR_EQUALS:
			return Status.SUCCESS if first_key_value >= second_key_value else Status.FAILURE
		ComparisonOperator.GREATER_THAN:
			return Status.SUCCESS if first_key_value < second_key_value else Status.FAILURE
		_:
			return Status.FAILURE
