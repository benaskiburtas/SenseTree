@tool
@icon("res://addons/sensetree/behavior_tree/icon/Condition.svg")
class_name SenseTreeHasResourceCondition
extends SenseTreeBlackboardCompareValueAction

const RESOURCE_STATUS_COMPARISON_OPERATOR = ComparisonOperator.GREATER_THAN

func _ready() -> void:
	self.comparison_operator = RESOURCE_STATUS_COMPARISON_OPERATOR
	self.comparison_value = "0"

func get_sensenode_class() -> String:
	return "SenseTreeHasResourceCondition"

func _validate_property(property: Dictionary) -> void:
	if property.name in ["comparison_operator", "comparison_value"]:
		property.usage = PROPERTY_USAGE_NO_EDITOR
