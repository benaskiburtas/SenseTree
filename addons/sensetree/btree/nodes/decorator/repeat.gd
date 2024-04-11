@tool
@icon("res://addons/sensetree/btree/icons/Repeat.svg")
class_name SenseTreeRepeatDecorator
extends SenseTreeDecorator

@export_range(0, 100000) var repeat_limit: int = 0

var _current_repetitions: int = 0


func _ready() -> void:
	_current_repetitions = 0


func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	if _current_repetitions >= repeat_limit:
		return Status.RUNNING
	else:
		var child = get_child(0)
		var result = child.tick(actor, blackboard)

		if result == Status.FAILURE:
			return Status.FAILURE
		if result == Status.RUNNING:
			return Status.RUNNING

		_current_repetitions += 1

		if _current_repetitions >= repeat_limit:
			return Status.SUCCESS

		return Status.RUNNING


func get_sensenode_class() -> String:
	return "SenseTreeRepeatDecorator"


func get_exported_properties() -> Array[SenseTreeExportedProperty]:
	return [SenseTreeExportedProperty.new("repeat_limit", "Repeat Limit", repeat_limit)]
