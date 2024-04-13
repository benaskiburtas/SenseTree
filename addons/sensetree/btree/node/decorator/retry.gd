@tool
@icon("res://addons/sensetree/btree/icon/Retry.svg")
class_name SenseTreeRetryDecorator
extends SenseTreeDecorator

@export_range(0, 100000) var retry_limit: int = 0

var _current_retries: int = 0


func _ready() -> void:
	_current_retries = 0


func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	if _current_retries < retry_limit:
		var child = get_child(0)
		var result = child.tick(actor, blackboard)

		if result == Status.SUCCESS:
			return Status.SUCCESS
		if result == Status.RUNNING:
			return Status.RUNNING

		_current_retries += 1

		if _current_retries >= retry_limit:
			return Status.FAILURE

		return Status.RUNNING
	else:
		return Status.FAILURE


func get_sensenode_class() -> String:
	return "SenseTreeRetryDecorator"


func get_exported_properties() -> Array[SenseTreeExportedProperty]:
	var retry_limit_property = SenseTreeExportedProperty.new()
	retry_limit_property.property_name = "retry_limit"
	retry_limit_property.property_title = "Retry Limit"
	retry_limit_property.value = retry_limit
	return [retry_limit_property]
