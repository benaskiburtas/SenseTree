@tool
class_name SenseTreeBlackboardModifyValueAction
extends SenseTreeActionLeaf

enum ModificationOperator { ADD, SUBTRACT, MULTIPLY, DIVIDE, EXPONENTIATION }

@export_placeholder("Blackboard key") var blackboard_key: String
@export_placeholder("Modification value") var modification_value: String
@export var modification_operator: ModificationOperator

var _expression: Expression = Expression.new()


func _get_configuration_warnings() -> PackedStringArray:
	var configuration_warnings: PackedStringArray = super._get_configuration_warnings()
	if not blackboard_key or blackboard_key.is_empty():
		configuration_warnings.push_back("Blackboard key for modification should be set.")
	if not modification_value or modification_value.is_empty():
		configuration_warnings.push_back("Value used in modification should be set.")
	if modification_value != null and not _is_number(modification_value):
		configuration_warnings.push_back("Value used in modification should be a number.")
	if not modification_operator:
		configuration_warnings.push_back("Modification operator should be selected.")
	return configuration_warnings


func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	if not blackboard_key or blackboard_key.is_empty():
		return Status.FAILURE

	if not modification_value or modification_value.is_empty():
		return Status.FAILURE

	var blackboard_value: Variant = blackboard.get_value(blackboard_key)

	if modification_value == null or modification_value == null:
		return Status.FAILURE

	if _validate_and_parse_expression(blackboard_value) != OK:
		return Status.FAILURE

	var modification_result = _expression.execute()
	blackboard[blackboard_key] = modification_result
	return Status.SUCCESS


func _validate_and_parse_expression(blackboard_value: Variant) -> Error:
	if not _is_number(blackboard_value) or not _is_number(modification_value):
		return ERR_INVALID_PARAMETER

	var expression_string: String
	match modification_operator:
		ModificationOperator.ADD:
			expression_string = "%d + %d" % [blackboard_value, modification_value]
		ModificationOperator.SUBTRACT:
			expression_string = "%d - %d" % [blackboard_value, modification_value]
		ModificationOperator.MULTIPLY:
			expression_string = "%d * %d" % [blackboard_value, modification_value]
		ModificationOperator.DIVIDE:
			expression_string = "%d / %d" % [blackboard_value, modification_value]
		ModificationOperator.EXPONENTIATION:
			expression_string = "pow(%d, %d)" % [blackboard_value, modification_value]

	var parse_result = _expression.parse(expression_string)
	return parse_result


func _is_number(input: Variant) -> bool:
	return true if typeof(input) == TYPE_INT or typeof(input) == TYPE_FLOAT else false
