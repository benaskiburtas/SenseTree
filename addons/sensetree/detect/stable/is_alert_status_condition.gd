@tool
@icon("res://addons/sensetree/btree/icon/Condition.svg")
class_name SenseTreeIsAlertStatusCondition
extends SenseTreeBlackboardCompareValueAction

enum AlertStatus { IDLE, SUSPICIOUS, ALERTED, INVESTIGATING, CHASING, SEARCHING, FLEEING }

const ALERT_STATUS_KEY: String = "ACTOR_ALERT_STATUS"
const ALERT_STATUS_COMPARISON_OPERATOR = ComparisonOperator.EQUALS

## Defines what the current actor state should be set to
@export var alert_status: AlertStatus


func _init() -> void:
	self.blackboard_key = ALERT_STATUS_KEY
	self.comparison_value = str(alert_status)
	self.comparison_operator = ALERT_STATUS_COMPARISON_OPERATOR


func _get_configuration_warnings() -> PackedStringArray:
	var configuration_warnings = []
	if alert_status == null:
		configuration_warnings.push_back("Alert status for comparison should be set.")
	return configuration_warnings


func get_sensenode_class() -> String:
	return "SenseTreeIsAlertStatusCondition"


func get_exported_properties() -> Array[SenseTreeExportedProperty]:
	var alert_status_property = SenseTreeExportedProperty.new(
		"alert_status", "Alert Status", AlertStatus.keys()[alert_status]
	)
	return [alert_status_property]


func _validate_property(property: Dictionary) -> void:
	if property.name in ["blackboard_key", "comparison_value", "comparison_operator"]:
		property.usage = PROPERTY_USAGE_NO_EDITOR
