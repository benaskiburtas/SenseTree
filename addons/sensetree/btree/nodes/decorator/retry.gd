@tool
@icon("res://addons/sensetree/btree/icons/Retry.svg")
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

func get_exported_properties() -> Array[SenseTreeExportedProperty]:
	return [SenseTreeExportedProperty.new("retry_limit", "Retry Limit", retry_limit)]
