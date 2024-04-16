@tool
@icon("res://addons/sensetree/btree/icon/Action.svg")
class_name SenseTreeSetAlertStatusAction
extends SenseTreeBlackboardAssignValueAction

enum AlertStatus { IDLE, SUSPICIOUS, ALERTED, INVESTIGATING, CHASING, SEARCHING, FLEEING }

const ALERT_STATUS_KEY: String = "ACTOR_ALERT_STATUS"

## Defines what the current actor state should be set to
@export var alert_status: AlertStatus = AlertStatus.IDLE


func _ready() -> void:
	self.blackboard_key = ALERT_STATUS_KEY
	self.key_value = AlertStatus.keys()[alert_status]


func _get_configuration_warnings() -> PackedStringArray:
	var configuration_warnings = []
	if alert_status == null:
		configuration_warnings.push_back("Alert status for assignment should be set.")
	return configuration_warnings


func get_sensenode_class() -> String:
	return "SenseTreeSetAlertStatusAction"


func get_exported_properties() -> Array[SenseTreeExportedProperty]:
	var alert_status_property = SenseTreeExportedProperty.new(
		"alert_status", "Alert Status", AlertStatus.keys()[alert_status]
	)
	return [alert_status_property]


func _validate_property(property: Dictionary) -> void:
	if property.name in ["blackboard_key", "key_value"]:
		property.usage = PROPERTY_USAGE_NO_EDITOR
