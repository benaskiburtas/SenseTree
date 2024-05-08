@tool
@icon("res://addons/sensetree/behavior_tree/icon/Blackboard_Modify_Value.svg")
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

	if blackboard_value == null:
		return Status.FAILURE

	if _validate_and_parse_expression(blackboard_value) != OK:
		return Status.FAILURE

	var modification_result = _expression.execute()
	var type = typeof(modification_result)
	blackboard.set_value(blackboard_key, str(modification_result))
	return Status.SUCCESS


func get_sensenode_class() -> String:
	return "SenseTreeBlackboardModifyValueAction"


func get_exported_properties() -> Array[SenseTreeExportedProperty]:
	var blackboard_key_property = SenseTreeExportedProperty.new(
		"blackboard_key", "Blackboard key", blackboard_key
	)
	var modification_value_property = SenseTreeExportedProperty.new(
		"modification_value", "Modification value", modification_value
	)
	var modification_operator_property = SenseTreeExportedProperty.new(
		"modification_operator",
		"Modification Opeartor",
		ModificationOperator.keys()[modification_operator]
	)
	return [blackboard_key_property, modification_value_property, modification_operator_property]


func _validate_and_parse_expression(blackboard_value: Variant) -> Error:
	if (
		typeof(blackboard_value) == TYPE_STRING
		and not blackboard_value.is_valid_float()
		and not blackboard_value.is_valid_int()
	):
		return ERR_INVALID_PARAMETER

	if (
		typeof(modification_value) == TYPE_STRING
		and not modification_value.is_valid_float()
		and not modification_value.is_valid_int()
	):
		return ERR_INVALID_PARAMETER

	var expression_string: String
	match modification_operator:
		ModificationOperator.ADD:
			expression_string = "%s + %s" % [blackboard_value, modification_value]
		ModificationOperator.SUBTRACT:
			expression_string = "%s - %s" % [blackboard_value, modification_value]
		ModificationOperator.MULTIPLY:
			expression_string = "%s * %s" % [blackboard_value, modification_value]
		ModificationOperator.DIVIDE:
			expression_string = "%s / %s" % [blackboard_value, modification_value]
		ModificationOperator.EXPONENTIATION:
			expression_string = "pow(%s, %s)" % [blackboard_value, modification_value]

	var parse_result = _expression.parse(expression_string)
	return parse_result


func _is_number(input: Variant) -> bool:
	return true if typeof(input) == TYPE_INT or typeof(input) == TYPE_FLOAT else false
