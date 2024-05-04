@tool
@icon("res://addons/sensetree/behavior_tree/icon/Retry.svg")
class_name SenseTreeRetryDecorator
extends SenseTreeDecorator

@export_range(0, 100000) var retry_limit: int = 5

var _current_retries: int = 0


func _ready() -> void:
	_current_retries = 0


func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	if get_child_count() == 0:
		_current_retries = 0
		return Status.FAILURE

	var child = get_child(0)
	var result = child.tick(actor, blackboard)

	if result == Status.SUCCESS:
		_current_retries = 0
		return Status.SUCCESS
	if result == Status.RUNNING:
		return Status.RUNNING

	_current_retries += 1

	if _current_retries >= retry_limit:
		_current_retries = 0
		return Status.FAILURE

	return Status.RUNNING


func get_sensenode_class() -> String:
	return "SenseTreeRetryDecorator"


func get_exported_properties() -> Array[SenseTreeExportedProperty]:
	var retry_limit_property = SenseTreeExportedProperty.new(
		"retry_limit", "Retry Limit", retry_limit
	)
	return [retry_limit_property]
