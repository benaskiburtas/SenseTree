@tool
@icon("res://addons/sensetree/behavior_tree/icon/Condition.svg")
class_name SenseTreeCheckNeedsCondition
extends SenseTreeBlackboardCompareValueAction

#Check an entities needs (hunger/thirst/rest)

enum NeedsStatus { HUNGRY, THIRST, FATIGUE}

const HUNGER_STATUS_KEY: String = "HUNGER_STATUS"
const THIRST_STATUS_KEY: String = "THIRST_STATUS"
const FATIGUE_STATUS_KEY: String = "FATIGUE_STATUS"
const NEED_STATUS_COMPARISON_OPERATOR = ComparisonOperator.GREATER_THAN_OR_EQUALS

@export var needs_status: NeedsStatus = NeedsStatus.HUNGRY
@export_range (0,100) var threshold_value: int = 100

func get_sensenode_class() -> String:
	return "SenseTreeCheckNeedsCondition"

func get_exported_properties() -> Array[SenseTreeExportedProperty]:
	var needs_status_property = SenseTreeExportedProperty.new(
		"needs_status", "Needs Status", needs_status
	)
	var threshold_value_property = SenseTreeExportedProperty.new(
		"threshold_value", "Threshold Value", threshold_value
	)
	return [needs_status_property]
