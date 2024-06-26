@tool
@icon("res://addons/sensetree/example/icon/Has_Resource.svg")
class_name SenseTreeHasResourceCondition
extends SenseTreeBlackboardCompareValueCondition

const RESOURCE_STATUS_COMPARISON_OPERATOR = ComparisonOperator.GREATER_THAN


func _ready() -> void:
	self.comparison_operator = RESOURCE_STATUS_COMPARISON_OPERATOR
	self.comparison_value = "0"


func get_sensenode_class() -> String:
	return "SenseTreeHasResourceCondition"


func _validate_property(property: Dictionary) -> void:
	if property.name in ["comparison_operator", "comparison_value"]:
		property.usage = PROPERTY_USAGE_NO_EDITOR
