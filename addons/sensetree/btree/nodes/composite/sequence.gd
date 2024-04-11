@tool
@icon("res://addons/sensetree/btree/icons/Sequence.svg")
class_name SenseTreeSequenceComposite
extends SenseTreeCompositeNode

var _last_success_index: int = 0


func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	for child_index in range(_last_success_index, get_children().size()):
		var child = get_child(child_index)
		var result: Status = child.tick(actor, blackboard)

		if result == Status.SUCCESS:
			_last_success_index = child_index
			continue

		if result == Status.FAILURE:
			reset()
			return Status.FAILURE

		if result == Status.RUNNING:
			return Status.RUNNING
	reset()
	return Status.SUCCESS


func reset() -> void:
	_last_success_index = 0


func get_sensenode_class() -> String:
	return "SenseTreeSequenceComposite"
