@tool
@icon("../../../icons/placeholder.svg")
class_name SenseTreeFailDecorator
extends SenseTreeDecorator

func tick(actor: Node, blackboard: SenseTreeBlackboard) -> Status:
	var child = get_child(0) as SenseTreeNode
	child.tick(actor, blackboard)
	return Status.FAILURE
