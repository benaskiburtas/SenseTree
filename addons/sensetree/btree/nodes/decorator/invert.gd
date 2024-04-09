@tool
@icon("res://addons/sensetree/btree/icons/Invert.svg")
class_name SenseTreeInvertDecorator
extends SenseTreeDecorator


func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	var child = get_child(0) as SenseTreeNode
	var child_status = child.tick(actor, blackboard)
	return return_inverted_status(child_status)


func return_inverted_status(child_status: Status) -> Status:
	if child_status == Status.SUCCESS:
		return Status.FAILURE
	if child_status == Status.FAILURE:
		return Status.SUCCESS
	return Status.RUNNING
